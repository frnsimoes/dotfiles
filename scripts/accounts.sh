account_identity() {
    aws sts get-caller-identity
}

account_export_env() {
    if [[ "$1" != "--profile" ]] || [[ -z "$2" ]]; then
	echo "Uso: importkeys --profile <nome_do_perfil>"
	return 1
    fi

    eval "$(aws configure export-credentials --format env --profile "$2")"
}
