echo "# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#MongoDb Database
mongodb.host=127.0.0.1
mongodb.db=test
mongodb.port=27017

#Virtuoso Database
virtuoso.host=jdbc:virtuoso://localhost:
virtuoso.port=1111
virtuoso.user=dba
virtuoso.password=dba

# Oauth2
oauth2.server=https://account.lab.fiware.org
oauth2.key=FIWAREKEY
oauth2.secret=FIWARESECRET
oauth2.callbackURL=http://localhost:8080/FiwareRepository/v2/callback" > /etc/default/Repository-RI.properties
