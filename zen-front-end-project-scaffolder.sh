#!/usr/bin/env bash

#==============================================================================
#
#        TITLE: Zen Front End Project Scaffolder - Minimalist JavaScript Scaffolding Solution
#        USAGE: new-site.sh
#
#  DESCRIPTION: The minimal scaffolding for a modular front-end JavaScript projects with tests
#               1.0 Suitable for VueJS or plain 'Vanilla JS' projects
#               ES6 modules as standard with an optional build step for tree-shaking
#
# REQUIREMENTS: BASH language and Javascript package manager installed
#         BUGS: ---
#        NOTES: Tested on Fedora Linux
#       AUTHOR: David Else
#      COMPANY: https://www.elsewebdevelopment.com/
#      VERSION: 1.0
#      CREATED: Oct 2018
#
# wget -P src https://cdn.jsdelivr.net/npm/tailwindcss/dist/tailwind.min.css
# mv src/tailwind.min.css src/main.css
#==============================================================================

# exit on non-zero exit status, undefined var, and any failure in pipeline
set -euo pipefail

#==============================================================================
# Global Constants
#==============================================================================
# ! create a function with PROJECT_ROOT as a local
PROJECT_ROOT=$HOME/sites
PACKAGE_MANAGER=pnpm # current options include pnpm, npm and yarn
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)
GITHUB_USERNAME=David-Else

#==============================================================================
# Scaffolding templates for JS projects
#==============================================================================
init_templates() {
    declare -gA base_template=(
        [production_packages]='' # for npm install
        [development_packages]='esm purgecss rollup mocha jsdom jsdom-global' # for npm install --save-dev
        [source_directory]=/common-files/ # where the files we are going to copy live
        [build_instructions]=$(
            cat <<EOF
.gitignore:.
jsconfig.json:.
launch.json:./.vscode/
main.css:./src/
:src/
:dist/
:test/
:vendor/
:assets/
:.vscode/
EOF
        )
    )

    declare -gA vanilla_template=(
        [production_packages]=''
        [development_packages]=''
        [source_directory]=/standard-template-files/
        [build_instructions]=$(
            cat <<EOF
index.html:.
main.js:./src/
app.js:./src/
app-test.js:./test/
:src/classes
EOF
        )
    )

    declare -gA vue_template=(
        [production_packages]='vue'
        [development_packages]='vue-template-compiler'
        [source_directory]=/vue-template-files/
        [build_instructions]=$(
            cat <<EOF
index.html:.
main.js:./src/
app.js:./src/
app-test.js:./test/
:src/components/
EOF
        )
    )
}

#==============================================================================
# Check all the required keys are present in all templates defined here
#==============================================================================
check_template_keys() {
    local template_titles=(base_template vanilla_template vue_template)
    local required_keys=(production_packages development_packages source_directory build_instructions)

    # check each template one at a time
    for template in "${template_titles[@]}"; do
        # check each required key to confirm it is present in the template
        for key in "${required_keys[@]}"; do
            if [[ ! -v $template[$key] ]]; then
                echo >&2 "${GREEN}${key}${RESET} key is missing in ${GREEN}${template}${RESET}" && exit 1
            fi
        done
    done
}

#==============================================================================
# Create the files and folders in current directory
#==============================================================================
create_files_folders() {
    local source_directory=$1
    local build_instructions=$2
    local dir_script_contained="$(dirname "$0")" # apparantly this is not an option! http://mywiki.wooledge.org/BashFAQ/028
    local file_folder=$dir_script_contained${source_directory}

    OLDIFS="$IFS"
    IFS=$'\n'
    # test files exist before writing
    for route in ${build_instructions}; do
        # split the line on the ':' and define the variables as what is on the left and right
        tplname="${route%%:*}"
        tplpath="${route#*:}"
        # if there is something on the left and right we know it is a file, not just a folder
        if [[ "$tplname" && "$tplpath" ]]; then
            if [[ ! -f "$file_folder""$tplname" ]]; then
                echo >&2 "File not found!${GREEN}""$file_folder""$tplname""${RESET}" && exit 1
            fi
        fi
    done
    # write files
    for route in ${build_instructions}; do
        tplname="${route%%:*}"
        tplpath="${route#*:}"
        if [[ "$tplname" && "$tplpath" ]]; then
            mkdir -p "${tplpath}"
            cp "$file_folder""$tplname" "${tplpath}"
        fi
        # if there was no file reference then its just a folder, so make it
        mkdir -p "${tplpath}"
    done
    echo "files copied and folders created OK!"
    IFS="$OLDIFS"
}

#==============================================================================
# Check you have the required files and folders available
#==============================================================================
function check_dependencies() {
    #add git, ? optional
    unset assoc
    if ! declare -A assoc; then
        echo >&2 echo "You have bash version $BASH_VERSION, associative arrays not supported! You need at least bash version 4"
        exit 1
    fi

    hash "$PACKAGE_MANAGER" 2>/dev/null || {
        echo >&2 "You need to install ${GREEN}$PACKAGE_MANAGER${RESET} to use this script" && exit 1
    }

    hash node 2>/dev/null || {
        echo >&2 "You need to install ${GREEN}Node.js${RESET} to use this script" && exit 1
    }
}

#==============================================================================
# Show preferences
#==============================================================================
function show_preferences() {
    echo "Package manager: ${GREEN}$PACKAGE_MANAGER${RESET}"
    echo "Project root: ${GREEN}$PROJECT_ROOT${RESET}"
    echo "Github user name: ${GREEN}$GITHUB_USERNAME${RESET}"
    echo
}

#==============================================================================
# Ask user for project directory name and create it in the project root folder
#==============================================================================
function get_user_input_sitename() {
    local text=$1
    local sitename
    read -rp "$text" sitename
    sitename=${sitename,,}    # make lower-case for compatibility across servers
    sitename=${sitename// /-} # use in-line shell string replacement to remove spaces and replace with -
    echo "$sitename"
}

#==============================================================================
# Get user y/n input and return true or false
#==============================================================================
function get_user_input_yes_no() {
    local text=$1
    read -p "$text (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo true
    else
        echo false
    fi
}

#==============================================================================
# Install template files
#==============================================================================
function install() {

    $PACKAGE_MANAGER init -y

    create_files_folders "${base_template[source_directory]}" "${base_template[build_instructions]}"
    npm_install "${base_template[production_packages]}" "${base_template[development_packages]}"

    if [ "$vue" = true ]; then
        create_files_folders "${vue_template[source_directory]}" "${vue_template[build_instructions]}"
        npm_install "${vue_template[production_packages]}" "${vue_template[development_packages]}"
        cp node_modules/vue/dist/vue.js vendor
    else
        create_files_folders "${vanilla_template[source_directory]}" "${vanilla_template[build_instructions]}"
        npm_install "${vanilla_template[production_packages]}" "${vanilla_template[development_packages]}"
    fi
}

#==============================================================================
# npm install the development and production packages if they exist in template
#==============================================================================
npm_install() {
    local production_packages=$1
    local development_packages=$2
    if [[ -n ${production_packages} ]]; then
        $PACKAGE_MANAGER install $production_packages
    fi
    if [[ -n ${development_packages} ]]; then
        $PACKAGE_MANAGER install --save-dev $development_packages
    fi
}

#==============================================================================
# Update package.json
#==============================================================================
function update_package_json() {
    node -p '
  const p = require("./package.json");
  p.scripts = {
    "global-install": "pnpm install -g mocha jsdom jsdom-global",
    "test": "mocha --reporter min --require esm --require jsdom-global/register -b",
    "test-watch": "mocha --watch --reporter min --require esm --require jsdom-global/register -b",
    "build": "rollup --format=iife --file=dist/bundle.js -- src/main.js && purgecss --css src/main.css --content index.html src/**/*.js --out dist"
  };
  JSON.stringify(p, null, 2);
' >package.json.tmp && mv package.json.tmp package.json
}

#==============================================================================
# Ask and setup git BROKEN
#==============================================================================
function ask_and_setup_git() {

    if [ "$git" = true ]; then
        git init >/dev/null 2>&1
        git add . >/dev/null 2>&1
        git commit -m 'first commit' >/dev/null 2>&1

        echo
        github=$(get_user_input_yes_no "Create Github remote repository called ${GREEN}$sitename${RESET} for user ${GREEN}$GITHUB_USERNAME${RESET} (paste password when prompted)?")

        if [ "$github" = true ]; then
            curl -u $GITHUB_USERNAME https://api.github.com/user/repos -d "{\"name\":\"$sitename\"}"
            git remote add origin git@github.com:$GITHUB_USERNAME/"$sitename".git
            git push -u origin master
        fi
    fi
    #/home/david/Documents/scripts/new-site-2.sh: line 213: i: command not found
}

function main() {
    clear
    show_preferences
    check_dependencies
    init_templates
    check_template_keys

    sitename=$(get_user_input_sitename "Enter name for new app/website: ")
    vue=$(get_user_input_yes_no "Install Vue?")
    echo
    git=$(get_user_input_yes_no "Run git init and commit files?")
    echo
    vscode=$(get_user_input_yes_no "Open project in Visual Studio Code?")
    echo

    mkdir "$PROJECT_ROOT/$sitename"
    cd "$PROJECT_ROOT/$sitename"
    echo "# $sitename" >>README.md
    install
    update_package_json
    ask_and_setup_git

    echo "Your new project directory is: ${GREEN}$PWD${RESET}"

    if [ "$vscode" = true ]; then
        GTK_IM_MODULE=ibus code .
    else
        exit
    fi
}
main
