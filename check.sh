#!/bin/bash

##--------------------------------------DEBIAN------------------------------------------------

PXC_80=("pxc-80")
PXC_80_repo_version=("p") # 2017 and 2018 dirs had 404 error
PXC_80_component_name=("percona-xtradb-cluster-full")
PXC_80_component_repository=("testing" "experimental" "main" "laboratory")
PXC_80_component_path=("percona-xtradb-cluster")

PXC_56=("pxc-56")
PXC_56_repo_version=("p") # 2017 and 2018 dirs had 404 error
PXC_56_component_name=("percona-xtradb-cluster-full" "percona-xtradb-cluster-galera-3.x-")
PXC_56_component_repository=("testing" "main")
PXC_56_component_path=("percona-xtradb-cluster-5.6" "percona-xtradb-cluster-galera-3.x")

PXB_24=("pxb-24")
PXB_24_repo_version=("2" "2017" "2018" "7" "7.8" "7Server" "8" "8.0" "8.0" "8.2" "8Server")
PXB_24_component_name=("percona-xtrabackup-24-2.4")
PXB_24_component_repository=("testing" "experimental" "release" "laboratory")
PXB_24_component_path=("" "" "" "" "")

PXB_80=("pxb-80")
PXB_80_repo_version=("2" "2017" "2018" "7" "7.8" "7Server" "8" "8.0" "8.0" "8.2" "8Server")
PXB_80_component_name=("percona-xtrabackup-80-8.0")
PXB_80_component_repository=("testing" "experimental" "release" "laboratory")
PXB_80_component_path=("" "" "" "" "")

##--------------------------------------DEBIAN------------------------------------------------

##-------------------------------------APT-----------------------------------------




##-------------------------------------APT-----------------------------------------



check_new_release_deb(){

        component=$1
        subpath=$2        
        version=$3
        repository=$4
        component_path=$5
                
        lftp -e "cls -1 > deb/$subpath-$version-$repository-apt; exit" "https://repo.percona.com/$version/apt/pool/$repository/$subpath/$component_path/"
        cat deb/$subpath-$version-$repository-apt | grep -i "$component" | sort > deb/release-$subpath-$version-$repository-$subpath-$component_path-$component
        rm -f deb/$subpath-$version-$repository-apt

}

driver_deb(){
    declare -n PRODUCT=$1
    declare -n REPO_VERSION=$2
    declare -n COMPONENT_NAME=$3
    declare -n REPOSITORY_NAME=$4
    declare -n COMPONENT_PATH=$5

    echo ${PRODUCT[@]}
    echo ${REPO_VERSION[@]}
    echo ${COMPONENT_NAME[@]}
    echo ${REPOSITORY_NAME[@]}
    echo ${COMPONENT_PATH[@]}

    for h in ${REPOSITORY_NAME[@]}
    do
        for i in ${PRODUCT[@]} 
        do
            for j in ${REPO_VERSION[@]} 
            do
                for k in ${COMPONENT_NAME[@]} 
                do
                    for l in ${COMPONENT_PATH[@]} 
                    do
                        check_new_release_deb $k $j $i $h $l
                    done
                done
            done
        done
    done

}
#-------------------------------------------DEB-----------------------------------------------
mkdir deb

LIST=("PXC_80" "PXC_56")

for a in ${LIST[@]}
do

driver_deb "$a" "${a}_repo_version" "${a}_component_name" "${a}_component_repository" "${a}_component_path"

done

echo """

-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------

"""
du -ksh deb/* | awk '{ print$2 }' | sort > /tmp/a-deb
du -ksh deb/* | grep "^0" | awk '{ print$2 }' | sort > /tmp/b-deb
diff /tmp/a-deb /tmp/b-deb | grep "<" | awk '{print$2}' > /tmp/diffed-deb

cat /tmp/diffed-deb
#-------------------------------------------RHEL-----------------------------------------------

FILES=$(cat /tmp/diffed-deb)

for i in $FILES
do 
    echo "File name..."
    echo "./$i"


done

