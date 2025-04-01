# Commands to interact with gRPC services

# List all methods on a gRPC server
export def "listall" [
    address: string # Address of the server
]: nothing -> table {
    grpcurl -plaintext $address list
        | lines
        | par-each {|s| grpcurl -plaintext $address list $s | lines } | flatten | sort
}
