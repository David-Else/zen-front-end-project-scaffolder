# Archived 12/2/2020

This was an attempt to create a JS scaffolding solution entirely in Bash. I since decided that this was stretching the language too far and am currently creating something similar using Deno instead: https://github.com/denoland/deno.

It remains a warning not to use Bash for anything more than simple scripts, but has some language use I might want as a reference in the future.

---

        TITLE: Zen Front End Project Scaffolder - Minimalist JavaScript Scaffolding Solution
        USAGE: new-site.sh

     DESCRIPTION: The minimal scaffolding for a modular front-end JavaScript projects with tests
                  1.0 Suitable for VueJS or plain 'Vanilla JS' projects
                  ES6 modules as standard with an optional build step for tree-shaking

    REQUIREMENTS: BASH language and Javascript package manager installed
            BUGS: ---
           NOTES: Tested on Fedora Linux
          AUTHOR: David Else
         COMPANY: https://www.elsewebdevelopment.com/
         VERSION: 1.0
         CREATED: Oct 2018

    wget -P src https://cdn.jsdelivr.net/npm/tailwindcss/dist/tailwind.min.css
    mv src/tailwind.min.css src/main.css
