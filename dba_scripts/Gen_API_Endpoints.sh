#
#
#
cat API_Endpoints.dat | while read BUFFER 
do
	export endpoint=${BUFFER}
	echo ${endpoint} was found...
 
	envsubst < API_Endpoints.template > ./Offload_Scripts/Run_${endpoint}.sql
 
done