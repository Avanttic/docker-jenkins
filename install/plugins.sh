#/bin/bash
v_dir=`dirname "$0"`
mkdir /var/lib/jenkins/plugins/
cd /var/lib/jenkins/plugins/

while read plugin
do
  wget "http://updates.jenkins-ci.org/latest/"$plugin".hpi"
done < <(cat $v_dir/plugins.txt)
