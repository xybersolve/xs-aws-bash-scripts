# ---------------------------------------
# COMMON VARIABLES
# ---------------------------------------
# aws related
declare REGION='us-west-2'
declare ACCOUNT_ID='734741078887'
declare ADMIN_EMAIL='xybersolve@gmail.com'
# colors
declare _xsRESET='\e[0m'
declare _xsDEFAULT='\e[39m'
declare _xsRED='\e[31m'
declare _xsGREEN='\e[32m'
declare _xsYELLOW='\e[33m'
declare _xsBLUE='\e[34m'
declare _xsMAGENTA='\e[35m'
declare _xsCYAN='\e[36m'
declare _xsLIGHTGRAY='\e[37m'
declare _xsDARKGRAY='\e[90m'
declare _xsLIGHTRED='\e[91m'
declare _xsLIGHTGREEN='\e[92m'
declare _xsLIGHTYELLOW='\e[93m'
declare _xsLIGHTBLUE='\e[94m'
declare _xsLIGHTMAGENTA='\e[95m'
declare _xsLIGHTCYAN='\e[96m'
declare _xsWHITE='\e[97m'
# ---------------------------------------
# COMMON FUNCTIONS
# ---------------------------------------
usage() {
  printf "${_xsLIGHTYELLOW}%s\n${_xsRESET}" "${SYNTAX}"
}

error() {
  printf "${_xsLIGHTRED}\n%b  %s\n${_xsRESET}" " ⚰️ " "Error: ${1}"
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
