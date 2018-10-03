# ---------------------------------------
# COMMON VARIABLES
# ---------------------------------------
declare REGION='us-west-2'
declare ACCOUNT_ID='734741078887'
declare ADMIN_EMAIL='xybersolve@gmail.com'

# ---------------------------------------
# COMMON FUNCTIONS
# ---------------------------------------
usage() {
  echo "${SYNTAX}"
}

error() {
  printf "\n%s\n" "Error: ${1}"
}

die() {
  error "${1}"
  usage
  printf "\n\n"
  exit "${2:-1}"
}

show_version() {
  printf "\n\n%s  %s\n\n\n" "${PROGNAME}" "${VERSION}"
  exit 0
}

show_help() {
  printf "\n\n"
  usage
  printf "\n\n"
  exit 0
}
