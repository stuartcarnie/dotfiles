function explain_analyze {
    if [[ $# != 2 ]]; then
        echo explain_analyze: incorrect arguments >&2
        return 1
    fi

    curl -qsS -H "Accept: application/csv" http://localhost:8086/query --data-urlencode "q=EXPLAIN ANALYZE $1" --data-urlencode "db=$2" | tail -n +2 | cut -c3- | tr -d '"'
}
