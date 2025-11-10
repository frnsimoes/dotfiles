sqs_list() {
  local region="us-east-1"
  
  AWS_PAGER="" aws sqs list-queues --region "$region" --query "QueueUrls[]" --output json | jq -r '.[]'
}
sqs_inspect() {
  local queues_string queue_array selected_queue
  local region="us-east-1"
  
  queues_string=$(AWS_PAGER="" aws sqs list-queues --region "$region" --query "QueueUrls[]" --output json)
  
  queue_array=($(echo "$queues_string" | jq -r '.[]'))
  
  if [[ ${#queue_array[@]} -eq 0 ]]; then
    echo "No queue found"
    return 1
  fi
  
  selected_queue=$(printf '%s\n' "${queue_array[@]}" | \
    fzf --height=50% \
        --border \
        --preview 'echo "URL: {}" | fold -w 80' \
        --preview-window=down:3:wrap \
        --header="Select a queue to inspect")
  
  if [[ -z "$selected_queue" ]]; then
    echo "No queue selected"
    return 1
  fi
  
  echo "Selected queue: $selected_queue"
  aws sqs get-queue-attributes \
    --queue-url "$selected_queue" \
    --attribute-names All \
    --region "$region" \
    --output json
}

