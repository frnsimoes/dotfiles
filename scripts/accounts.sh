account_identity() {
    aws sts get-caller-identity
}

account_export_env() {
    if [[ "$1" != "--profile" ]] || [[ -z "$2" ]]; then
        echo "Uso: importkeys --profile <nome_do_perfil>"
        return 1
    fi
    
    # Tenta exportar as credenciais
    if ! eval "$(aws configure export-credentials --format env --profile "$2" 2>&1)"; then
        echo "Token expirado. Fazendo login no SSO..."
        aws sso login --profile "$2"
        eval "$(aws configure export-credentials --format env --profile "$2")"
    fi
}

account_unset() {
    unset AWS_PROFILE
    unset AWS_ACCESS_KEY_ID  
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
}
