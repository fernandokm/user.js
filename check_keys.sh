# Checks for duplicate keys (on stderr)
# and prints a sorted list of key-value pairs (on stdout)

node <<EOF
let d = {}
function user_pref(k,v) {
    if (d.hasOwnProperty(k)) {
        console.error("Duplicate key:", k, ", ignoring initial value");
    }
    d[k] = v;
}
`cat $1`
for (let k of Object.keys(d).sort()) {
    console.log(k, "=", d[k])
}
EOF
