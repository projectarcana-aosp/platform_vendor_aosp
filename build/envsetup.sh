function __print_aosp_functions_help() {
cat <<EOF
Additional AOSP functions:
- gerrit:          Adds a remote for Arcana Gerrit
EOF
}

function repopick() {
    T=$(gettop)
    $T/vendor/aosp/build/tools/repopick.py $@
}

function gerrit()
{
    if [ ! -d ".git" ]; then
        echo -e "Please run this inside a git directory";
    else
        if [[ ! -z $(git config --get remote.gerrit.url) ]]; then
            git remote rm gerrit;
        fi
        [[ -z "${GERRIT_USER}" ]] && export GERRIT_USER=$(git config --get gerrit.projectarcana.com.username);
        if [[ -z "${GERRIT_USER}" ]]; then
            git remote add gerrit $(git remote -v | grep ProjectArcana | awk '{print $2}' | uniq | sed -e "s|https://github.com/ProjectArcana|ssh://gerrit.projectarcana.com:29418/ProjectArcana|");
        else
            git remote add gerrit $(git remote -v | grep ProjectArcana | awk '{print $2}' | uniq | sed -e "s|https://github.com/ProjectArcana|ssh://${GERRIT_USER}@gerrit.projectarcana.com:29418/ProjectArcana|");
        fi
    fi
}

function fixup_common_out_dir() {
    common_out_dir=$(get_build_var OUT_DIR)/target/common
    target_device=$(get_build_var TARGET_DEVICE)
    common_target_out=common-${target_device}
    if [ ! -z $AOSP_FIXUP_COMMON_OUT ]; then
        if [ -d ${common_out_dir} ] && [ ! -L ${common_out_dir} ]; then
            mv ${common_out_dir} ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        else
            [ -L ${common_out_dir} ] && rm ${common_out_dir}
            mkdir -p ${common_out_dir}-${target_device}
            ln -s ${common_target_out} ${common_out_dir}
        fi
    else
        [ -L ${common_out_dir} ] && rm ${common_out_dir}
        mkdir -p ${common_out_dir}
    fi
}

