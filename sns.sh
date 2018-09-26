#!/usr/bin/env bash

__send_email() {
  local message="${1}"
  local subject="${2}"
  local topic="${3}"
  local topic_arn=$( __get_topic_arn "${topic}" )

  aws sns publish \
    --message "${message}" \
    --topic-arn "${topic_arn}" \
    --phone-number "${phone-number}"

    aws sns publish \
      --topic-arn arn:aws:sns:x:x:x \
      --region=$AWS_DEFAULT_REGION \
      --subject "Processing Error - ${tablename}" \
      --message "An error has occurred in API data processing. The error file ${error_file} has been written to the errors folder...The file contents of ${error_file} are : $(cat ${error_file})"

}

__send_sms() {
  :
}

__get_topic_arn() {
  local name="${1}"
}

__opt_in_phone_number() {
  aws sns opt-in-phone-number
}
