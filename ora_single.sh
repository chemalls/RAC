# preinstall
mkdir /opt/oracle
echo "192.168.6.44 oracle1" >> /etc/hosts

yum -y install oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm
passwd oracle

# install oracle software
chown -R oracle:oinstall /opt/oracle
chmod -R 755 /opt/oracle
rpm -ivh oracle-database-ee-19c-1.0-1.x86_64.rpm

# config dbca
cd /etc/sysconfig
cp oracledb_ORCLCDB-19c.conf oracledb_db1-19c.conf
cat oracledb_db1-19c.conf

cd /etc/init.d/
cp oracledb_ORCLCDB-19c oracledb_db1-19c
sed -i s/ORCLCDB/db1/g oracledb_db1-19c
sed -i s/ORCLPDB1/pdb1/g oracledb_db1-19c
sed -i s/AL32UTF8/ZHS16GBK/g oracledb_db1-19c

# dbca
/etc/init.d/oracledb_db1-19c configure

# config oracle user env variable
cat >> /home/oracle/.bash_profile << EOF
umask 022
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/19c/dbhome_1
export ORACLE_UNQNAME=db1
export ORACLE_SID=db1
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK
export PATH=.:\$PATH:\$ORACLE_HOME/bin
alias sqlplus="rlwrap sqlplus"
alias rman="rlwrap rman"
EOF

# stop and start database
/etc/init.d/oracledb_db1-19c stop
/etc/init.d/oracledb_db1-19c start
su - oracle
lsnrctl status
ps -ef |grep smon

# config sqlplus
yum -y install make gcc readline readline-devel
tar zxvf rlwrap-0.42.tar.gz
cd rlwrap-0.42
./configure
make && make install

# sqlplus "/as sysdba"
et line 200 pages 100
select instance_name,status,host_name from gv$instance;
