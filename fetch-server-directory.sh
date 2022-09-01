#!/bin/bash

PXC=("pxc-80" "pxc-56" "pxc-57")
PXC_repo_version=("2" "2017" "2018" "7" "7.8" "7Server" "8" "8.0" "8.0" "8.2" "8Server")
PXC_component_name=("percona-xtradb-cluster-full")

PXB_24=("pxb-24")
PXB_24_repo_version=("2" "2017" "2018" "7" "7.8" "7Server" "8" "8.0" "8.0" "8.2" "8Server")
PXB_24_component_name=("percona-xtrabackup-24-2.4")

PXB_80=("pxb-80")
PXB_80_repo_version=("2" "2017" "2018" "7" "7.8" "7Server" "8" "8.0" "8.0" "8.2" "8Server")
PXB_80_component_name=("percona-xtrabackup-80-8.0")


check_new_release(){

        component=$1
        subpath=$2        
        version=$3

        lftp -e "cls -1 > $subpath-$version-yum; exit" "https://repo.percona.com/$version/yum/testing/$subpath/RPMS/x86_64/"
      
        cat $subpath-$version-yum | grep -i "$component" | sort > release-$subpath-$version
        rm -f $subpath-$version-yum

}



main(){
    declare -n PRODUCT=$1
    declare -n REPO_VERSION=$2
    declare -n COMPONENT_NAME=$3

    echo ${PRODUCT[@]}
    echo ${REPO_VERSION[@]}
    echo ${COMPONENT_NAME[@]}

    for i in ${PRODUCT[@]} 
    do

        for j in ${REPO_VERSION[@]} 
        do

            for k in ${COMPONENT_NAME[@]} 
            do

            check_new_release $k $j $i
        
            done
        done

    done
}

LIST=("PXC" "PXB_24" "PXB_80")

for a in ${LIST[@]}
do

main "$a" "${a}_repo_version" "${a}_component_name"

done
