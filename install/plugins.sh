#/bin/bash
v_dir=`dirname "$0"`
if [ ! -d /var/lib/jenkins/plugins/ ]
then
  mkdir /var/lib/jenkins/plugins/
fi

cd /var/lib/jenkins/plugins/

cat $v_dir/plugins.txt | while read plugin
do
  wget "http://updates.jenkins-ci.org/latest/"$plugin".hpi"
done

chown -R jenkins. /var/lib/jenkins/plugins/
