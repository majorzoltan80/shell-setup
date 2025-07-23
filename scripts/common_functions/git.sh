function standardize_branchname() {
  # Converts the string by
  #  - Removing all non-alphanumeric characters by replacing with dashes
  #  - removing multiple dashes to only remain one between each word
  #  - converting to lowercase
  #  - if the branchname contains the jira ticket already it will convert the seon substring to uppercased SEON
  #  - Limit length to 100
  #  - Will not end with dash
  # example: "Task/SeOn-12345_String to 'Convert': small.HIGH " -> "task/SEON-12345-string-to-convert-small-high"

  input_string=$1
  # Removing all non-alphanumeric characters by replacing with dashes
  standardized_branchname=$(echo "${input_string//[^a-zA-Z0-9]/-}")

  # Remove duplicate dashes
  standardized_branchname=$(echo ${standardized_branchname} | sed -r "s/-+/-/g")

  # convert to lowercase
  standardized_branchname=$(echo ${standardized_branchname} | tr '[:upper:]' '[:lower:]')

  # Convert seon to SEON
  standardized_branchname=$(echo ${standardized_branchname} | sed "s|-seon-|/SEON-|g")

  # Limit length to 100 characters
  standardized_branchname=$(echo "${standardized_branchname:0:100}")

  # Remove training dash if present
  standardized_branchname=$(echo "${standardized_branchname%-}")

  echo "${standardized_branchname}"
}