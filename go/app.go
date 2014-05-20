package main

import (
    "runtime"
    "net/http"
    "fmt"
)

func main() {
    runtime.GOMAXPROCS(5*runtime.NumCPU())
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello, World!")
    })
    http.ListenAndServe("127.0.0.1:8000", nil)
}
