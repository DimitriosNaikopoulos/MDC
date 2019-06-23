package main

import (
    "database/sql"
    "log"
    "net/http"
    "text/template"
    "strings"

    _ "github.com/go-sql-driver/mysql"
)

type Quiz struct {
    Id    int
    Title  string
    Description string
    Total int
}

type Questions struct {
    Id    int
    Question  string
    Ans1 string
    Ans2 string
    Ans3 string
    Ans4 string
    Correct string
}

func dbConn() (db *sql.DB) {
    dbDriver := "mysql"
    dbUser := "root"
    dbPass := ""
    dbName := "mdc"
    db, err := sql.Open(dbDriver, dbUser+":"+dbPass+"@/"+dbName)
    if err != nil {
        panic(err.Error())
    }
    return db
}

var tmpl = template.Must(template.ParseGlob("website/*"))

func Index(w http.ResponseWriter, r *http.Request) {
    tmpl.ExecuteTemplate(w, "Index", nil)
}

func Main_page(w http.ResponseWriter, r *http.Request) {
    log.Println("ok")
    db := dbConn()
    email := r.URL.Query().Get("email")
    selDB, err := db.Query("SELECT * FROM Quiz AS q WHERE NOT(q.IDquiz = ANY (SELECT IDquiz FROM user_has_results AS u WHERE u.email = ? ));", email)
    log.Println(selDB)
    if err != nil {
        panic(err.Error())
    }
    quiz := Quiz{}
    res := []Quiz{}
    for selDB.Next() {
        var IDquiz, total_tries int
        var title, description string
        err = selDB.Scan(&IDquiz, &title, &description, &total_tries)
        if err != nil {
            panic(err.Error())
        }
        quiz.Id = IDquiz
        quiz.Title = title
        quiz.Description = description
        quiz.Total = total_tries
        res = append(res, quiz)
    }
    log.Println("ok")
    log.Println(res)
    tmpl.ExecuteTemplate(w, "Main_page", res)
    log.Println("ok")
    defer db.Close()
}

func Select_quiz(w http.ResponseWriter, r *http.Request) {
    db := dbConn()
    qID := r.URL.Query().Get("id")
    selDB, err := db.Query("SELECT IDquestion,QuestionText,Answers,Correct FROM questions WHERE IDquiz= ? ;", qID)
    if err != nil {
        panic(err.Error())
    }
    q := Questions{}
    res := []Questions{}
    for selDB.Next() {
        var id int
        var question, Answers, Correct string
        err = selDB.Scan(&id, &question, &Answers, &Correct)
        if err != nil {
            panic(err.Error())
        }
        q.Id = id
        q.Question = question
        log.Println("ok2")
        s := strings.Split(Answers, ";")
        q.Ans1 = s[0]
        q.Ans2 = s[1]
        q.Ans3 = s[2]
        q.Ans4 = s[3]
        q.Correct = Correct
        log.Println("ok2")
        log.Println(q)
        res = append(res, q)
    }
    log.Println("ok3")
    log.Println(res)
    tmpl.ExecuteTemplate(w, "Quiz", res)
    defer db.Close()
}

func Login(w http.ResponseWriter, r *http.Request) {
    db := dbConn()
    if r.Method == "POST" {
        email := r.FormValue("email")
        insForm, err := db.Prepare("INSERT INTO User(email) VALUES(?)")
        if err != nil {
            panic(err.Error())
        }
        insForm.Exec(email)
        log.Println("INSERT: Email: " + email +" ;")
    }
    defer db.Close()
    http.Redirect(w, r, "/main_page", 301)
}

func main() {
    log.Println("Server started on: http://localhost:8080")
    http.HandleFunc("/", Index)
    http.HandleFunc("/select_quiz", Select_quiz)
    http.HandleFunc("/login", Login)
    http.HandleFunc("/main_page", Main_page)
    http.ListenAndServe(":8080", nil)
}
