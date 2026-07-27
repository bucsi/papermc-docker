#!/usr/bin/env nu

cd papermc

def http-get-with-user-agent [url: string] { 
    http get -H { User-Agent: `papermc-docker/0.1 (papermc-docker@bucsi.net)` } $url
}

let api = "https://fill.papermc.io/v3/projects/paper"

let mc_version_env = ($env.MC_VERSION? | default "latest" | str downcase)

let mc_version = if $mc_version_env == "latest" {
    let project = (http-get-with-user-agent $api)
    $project.versions | values | get 0 | get 0
} else {
    $mc_version_env
}

let build = (http-get-with-user-agent $"($api)/versions/($mc_version)/builds" | where channel == "STABLE" | sort-by id)
if ($build | is-empty) {
    print $"No stable Paper build available for Minecraft ($mc_version). Try a different MC_VERSION, or set PAPER_BUILD explicitly if you want an unstable build."
    exit 1
}

let build_info = $build | last
let jar_name = $build_info.downloads."server:default".name
let download_url = $build_info.downloads."server:default".url

if not ($jar_name | path exists) {
    ls *.jar | each { |f| rm $f.name }
    http-get-with-user-agent $download_url | save $jar_name
}

$"eula=($env.EULA? | default 'false')\n" | save -f eula.txt

mut java_opts = ($env.JAVA_OPTS? | default "")
if ($env.MC_RAM? | is-not-empty) {
    $java_opts = $"-Xms($env.MC_RAM) -Xmx($env.MC_RAM) ($java_opts)"
}

exec java -server ...($java_opts | split row " " | where {|x| $x != ""}) -jar $jar_name nogui