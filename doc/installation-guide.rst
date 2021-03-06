=====================================
Installation and Administration Guide
=====================================

------------
Introduction
------------

This Installation and Administration Guide covers Repository-RI version 4.4.3. Any feedback on this document is highly welcomed, including bugs, typos or things you think should be included but aren't. Please send it to the "Contact Person" email that appears in the `Catalogue page for this GEi <http://catalogue.fiware.org/enablers/repository-repository-ri>`__.

-------------------
System Requirements
-------------------

Hardware Requirements
=====================

The following table contains the minimum resource requirements for running the Repository: 

* CPU: 1-2 cores with at least 2.4 GHZ
* Physical RAM: 1G-2GB
* Disk Space: 25GB The actual disk space depends on the amount of data being stored within the Repositories NoSQL database System.

Operating System Support
========================
The Repository has been tested in the following Operating Systems:

* Ubuntu 12.04, 14.04
* CentOS 6.3, 6.5, 7.0
* Debian 7

Software Requirements
===================== 
In order to have the Repository running, the following software is needed. However, these dependencies are not meant to be installed manually in this step, as they will be installed throughout the documentation:

* MongoDB 2.x - mandatory
* Java 1.8.x - mandatory
* Virtuoso 7.x - mandatory
* Application Server, Apache Tomcat 8.x - mandatory
* Repository Software - mandatory
* Mongo Shell - optional (JavaScript shell that allows you to execute commands on the internal data store of the Repository from the command line)

To install the required version of Virtuoso, it is possible to download a compiled version for the suported Operative Systems or it is possible to compile it from the source code. In this way, the installation of Virtuoso has some extra requirements, that will be also installed throughout this document.

* autoconf
* automake
* libtool
* flex
* bison
* gperf
* gawk
* m4
* make
* openssl
* openssl-devel

---------------------
Software Installation
---------------------

Getting the Repository software
===============================

The packaged version of the Repository software can be downloaded from:

* `The FIWARE Files page <https://forge.fiware.org/frs/?group_id=7>`__
* `The FIWARE catalgue <http://catalogue.fiware.org/enablers/repository-repository-ri/downloads>`__.

This package contains the war file of the Repository as well as the intallation scripts used in this document.

Alternatively, it is possible to install the Repository from the sources published in GitHub. To clone the repository, the git package is needed: ::

    # Ubuntu/Debian
    $ apt-get install git

    # CentOS
    $ yum -y install git


To download the source code usig git, execute the following command: ::

    $ git clone https://github.com/conwetlab/Repository-RI.git


Installing the Repository using scripts
=======================================

In order to facilitate the installation of the Repository, the script *install.sh* has been provided. This script installs all needed dependencies, configures the repository and deploys it. 

Note that the installation script installs dependencies such as Java 1.8 or Tomcat. If you are installing the Repository in a system that is already in use, you may want to have more control over what dependecies are installed. In this case have a look at section *Manually Installing the Repository*.

To use the installation script execute the following command: ::

    $ ./install.sh


The installation script also optionally resolves the extra dependencies that are needed for the installation of Virtuoso.

    Some packages are needed for installing Virtuoso: autoconf, automake, libtoo, flex, bison, gperf, gawk, m4, make, openssl, openssl-devel
    Do you want to install them? Y/N


Finally, the installation script allows to configure the OAuth2 user authentication. ::

    Do you want to activate OAuth2 authentication in the Repository? Y/N
    y
    
    The default OAuth2 enpoint is http://account.lab.fiware.org
    Do you want to provide a different idm enpoint? Y/N
    n
    
    What is your FIWARE Client id?
    [client id]
    
    What is your FIWARE Client Secret?
    [client secret]
    
    What is your Callback URL?
    http://[host]:[port]/FiwareRepository/v2/callback


.. note::
   The existing scripts try to install tomcat 8.0.26, in case this version would not be available it will be needed to update the version in the script installTomcat8.sh


Manually installing the Repository
==================================

Debian
------

All the mandatory dependencies can be easily installed on a debian based Linux distribution using diferent scripts: ::

    $ export INSPWD=$PWD
    $ export REPO_OS=debian
    $ ./scripts/installTools.sh
    $ ./scripts/installJava8.sh
    $ ./scripts/installTomcat8.sh
    $ ./scripts/installMongoDB.sh
    $ ./scripts/installVirtuoso7.sh


To install Virtuoso from the source code, it is also provided an script: ::

    $ export REPO_OS=""
    $ ./scripts/installVirtuoso7.sh


The variable ``INSPWD`` contains the path where the repository (Virtuoso, and Tomcat) has been installed.

Ubuntu
------

All the mandatory dependencies can be easily installed on a debian based Linux distribution using diferent scripts, and replacing "XX.XX" by Ubuntu version. ::

    $ export INSPWD=$PWD
    $ export REPO_OS=ubuntuXX.XX
    $ ./scripts/installTools.sh
    $ ./scripts/installJava8.sh
    $ ./scripts/installTomcat8.sh
    $ ./scripts/installMongoDB.sh
    $ ./scripts/installVirtuoso7.sh


The variable ``INSPWD`` contains the path where the repository (Virtuoso, and Tomcat) has been installed.

CentOS/RedHat
-------------

Similarly, the different dependencies can be installed in CentOS/RedHat, and replacing "X" by Centos version. ::

    $ export INSPWD=$PWD
    $ export REPO_OS=centosX
    $ ./scripts/installTools.sh
    $ ./scripts/installJava8.sh
    $ ./scripts/installTomcat8.sh
    $ ./scripts/installMongoDB.sh
    $ ./scripts/installVirtuoso7.sh


To install Virtuoso from the source code, it is also provided an script: ::

    $ export REPO_OS=""
    $ ./scripts/installVirtuoso7.sh


The variable ``INSPWD`` contains the path where the repository (Virtuoso, and Tomcat) has been installed.


-------------
Configuration
-------------

This configuration section assumes that the enviroment variable INSPWD exists, this variable is created during the installation process. If it does not exists execute the following command from the directory where the repository have been installed: ::

    $ export INSPWD=$PWD


Please note that if you have used the script *install.sh* you can skip *Virtuoso 7 Configuration* and *Tomcat 8 Configuration* sections, since the specified actions are performed by the script. 
 
Virtuoso 7 Configuration
========================

The first step is to create and configure the Virtuoso database to store RDF content. You may need to have root rights to do that. ::

    $ cd $INSPWD/virtuoso7/var/lib/virtuoso/db/
    $ $INSPWD/virtuoso7/bin/virtuoso-t -f &
    $ cd $INSPWD


This allows you to start the Virtuoso database. To make avanced configuration you can edit the file ``$INSPWD/virtuoso7/var/lib/virtuoso/db/virtuoso.ini`` by your own.

MongoDB Configuration
=====================

By default the Database saves its data in ``/var/lib/mongodb``. Since all the Resources you upload to the Repository are stored there, the size of this folder can grow rapidly.
If you want to relocate that folder, you have to edit ``/etc/mongodb.conf`` ::

    # mongodb.conf

    # Where to store the data.
    dbpath=/var/lib/mongodb


Tomcat 8 Configuration
======================

To continue, the next step is to start and to configurate Tomcat 8. You may need to have root rights to do that. ::

    $ cd $INSPWD/apache-tomcat/bin/
    $ ./shutdown.sh
    $ ./startup.sh
    $ cd


To start Apache Tomcat 8 is necesary to have some variables well configurated like ``CATALINA_HOME, JAVA_HOME``. Maybe you will need configure them if you make a manual installation. 

It is possible to use the Apache Tomcat Application server as is, that is, without any further configuration. However, it is recommended to allow incoming connections to the Repository only through HTTPS. 
This can be achieved by using a front-end HTTPS server that will proxy all requests to Repository, or by configuring the Application Server in order to accept only HTTPS/SSL connection, please refer to http://tomcat.apache.org/tomcat-8.0-doc/ssl-howto.html for more information.


Repository Configuration
========================

If you have installed the Repository manually, you have to deploy the Repository software to your Application Server. For that you have to copy the Repository WAR package into the "webapp" folder of Apache Tomcat. To install it on other Java Application Servers (e.g. JBoss), please refer to the specific application server guidelines.

Also, you have to create a properties file located at ``/etc/default/Repository-RI.properties`` with the configuration of the repository. To create the properties file with basic configuration it is possible to use the script ``repositorySettings.sh``.

The repository can use OAuth2 authentication with FIWARE Lab accounts. If you have used the automatic installation script you have been already asked to choose whether you want to use this authentication mechanism and to provide OAuth2 credentials in that case. 

Before enabling OAuth2 authentication in the Repository, it is needed to have registered it on the corresponding idM (KeyRock) instance. 

It is needed to provide:
* A name for the application
* A description
* The URL of the Repository
* The callback URL of the Repository: http://[host]:[port]/FiwareRepository/v2/callback?client_name=FIWAREClient

The OAuth2 authentication can be enabled and disabled modifiying the file ``web.xml`` located at ``WEB-INF/web.xml``.

To enable OAuth2 include ``securityOAuth2.xml`` ::

    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>
            /WEB-INF/securityOAuth2.xml
        </param-value>
    </context-param>


To disable OAuth2 include ``noSecurity.xml`` ::
 
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>
            /WEB-INF/noSecurity.xml
        </param-value>
    </context-param>


You can modify OAuth2 credentials in the ``Repository-RI.properties`` file located at ``/etc/default/Repository-RI.properties`` ::

    oauth2.server=https://account.lab.fiware.org
    oauth2.key=[Client id]
    oauth2.secret=[Client secret]
    oauth2.callbackURL=http://[host]/FiwareRepository/v2/callback


.. note::
   If you have decided to use OAuth2 authentication you will need to modify ``oauth2.callbackURL`` property to include the host where the Repository is going to run. 


Finally, you can configure the MongoDB and Virtuoso instances the Repository is going to use in ``Repository-RI.properties``, which contains the following values by default. ::

    #MongoDb Database
    mongodb.host=127.0.0.1
    mongodb.db=test
    mongodb.port=27017

    #Virtuoso Database
    virtuoso.host=jdbc:virtuoso://localhost:
    virtuoso.port=1111
    virtuoso.user=dba
    virtuoso.password=dba


-----------------------
Sanity check procedures
-----------------------

The Sanity Check Procedures are those activities that a System Administrator has to perform to verify that an installation is ready to be tested. 
Therefore there is a preliminary set of tests to ensure that obvious or basic malfunctioning is fixed before proceeding to unit tests, integration tests and user validation.


End to End testing
==================

Although one End to End testing must be associated to the Integration Test, we can show here a quick testing to check that everything is up and running.
The first test step involves creating a new resource as well as the implicit creation of a collection. The second test step checks if meta information in different file formats can be obtained.

Step 1 - Create the Resource
----------------------------

Create a file named resource.xml with resource content like this. ::

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <resource>
	   <creator>Yo</creator>
	   <creationDate></creationDate>
	   <modificationDate></modificationDate>
	   <name>Resource Example</name>
	   <contentUrl>http://localhost:8080/FiwareRepository/v2/collec/collectionA/collectionB/ResourceExample</contentUrl>
	   <contentFileName>http://whereistheresource.com/ResourceExample</contentFileName>
    </resource>


Send the request: ::

    curl -v -H "Content-Type: application/xml" -X POST --data "@resource.xml" http://[SERVER_URL]:8080/FiwareRepository/v2/collec/


You should receive a HTTP/1.1 201 as status code

Create a file named resourceContent.txt with arbitrary content. ::

    curl -v -H "Content-Type: text/plain" -X PUT --data "@resourceContent.txt" http://localhost:8080/FiwareRepository/v2/collec/collectionA/collectionB/ResourceExample


You should receive a HTTP/1.1 200 as status code


Step 2 - Retrieve meta information
----------------------------------

Test HTML Response:

Open ``http://[SERVER_URL]:8080/FiwareRepository/v2/collec/collectionA/`` in your web browser. You should receive meta information about the implicit created collection in HTML format.

Test Text Response: ::

    curl -v -H "Content-Type: text/plain" -X GET http://[SERVER_URL]:8080/FiwareRepository/v2/collectionA/collectionB/ResourceExample


You should receive meta information about the implicit created collection in text format. 
You may use curl to also test the other supported content types (``application/json``, ``application/rdf+xml``, ``text/turtle``, ``text/n3``, ``text/html``, ``text/plain``, ``application/xml``)

List of Running Processes
=========================

You can execute the command ``ps -ax | grep 'tomcat\|mongo\|virtuoso'`` to check that the Tomcat web server, the Mongo database, and Virtuoso Triple Store are running. It should show a message text similar to the following: ::

     1048 ?        Ssl    0:51 /usr/bin/mongod --config /etc/mongodb.conf
     1112 pts/1    SNl    0:01 virtuoso-t -f
     1152 ?        Sl     0:03 /usr/lib/jvm/java-8-oracle/bin/java -Djava.util.logging.config.file=/home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Dhttp.nonProxyHosts=localhost|127.0.0.1|CONWETLABJORTIZ -Djava.endorsed.dirs=/home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26/endorsed -classpath /home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26/bin/bootstrap.jar:/home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26/bin/tomcat-juli.jar -Dcatalina.base=/home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26 -Dcatalina.home=/home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26 -Djava.io.tmpdir=/home/jortiz/conwet/Repository-RI/apache-tomcat-8.0.26/temp org.apache.catalina.startup.Bootstrap start
     2031 pts/1    S+     0:00 grep --color=auto --exclude-dir=.bzr --exclude-dir=.cvs --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn tomcat\|mongo\|virtuoso


Network interfaces Up & Open
============================

To check whether the ports in use are listening, execute the command ``netstat -ntpl``. The expected results must be somehow similar to the following: ::

    tcp        0      0 127.0.0.1:28017         0.0.0.0:*               ESCUCHAR    -               
    tcp        0      0 127.0.1.1:53            0.0.0.0:*               ESCUCHAR    -               
    tcp        0      0 0.0.0.0:1111            0.0.0.0:*               ESCUCHAR    11271/virtuoso-t
    tcp        0      0 127.0.0.1:631           0.0.0.0:*               ESCUCHAR    -               
    tcp        0      0 0.0.0.0:8890            0.0.0.0:*               ESCUCHAR    11271/virtuoso-t
    tcp        0      0 127.0.0.1:27017         0.0.0.0:*               ESCUCHAR    -               
    tcp6       0      0 :::8080                 :::*                    ESCUCHAR    11286/java      
    tcp6       0      0 ::1:631                 :::*                    ESCUCHAR    -               
    tcp6       0      0 127.0.0.1:8005          :::*                    ESCUCHAR    11286/java      
    tcp6       0      0 :::8009                 :::*                    ESCUCHAR    11286/java      


Databases
=========

The last step in the sanity check (once that we have identified the processes and ports) is to check the databases that has to be up and accept queries. For that, we execute the following commands:

* MongoDb ::

    $ mongo
    MongoDB shell version: 2.4.9
    connecting to: test
    Welcome to the MongoDB shell.
    For interactive help, type "help".
    For more comprehensive documentation, see
    http://docs.mongodb.org/
    Questions? Try the support group
    http://groups.google.com/group/mongodb-user
    > db


It should show a message text similar to the following: ::

    test


* Virtuoso ::
    
    $isql
    OpenLink Interactive SQL (Virtuoso), version 0.9849b.
    Type HELP; for help and EXIT; to exit.
    SQL> SPARQL SELECT DISTINCT ?g WHERE { GRAPH ?g { ?s ?q ?l }};


It should show a message text similar to the following: ::

    g
    LONG VARCHAR
    _______________________________________________________________________________

    http://www.openlinksw.com/schemas/virtrdf#
    http://www.w3.org/ns/ldp#
    http://localhost:8890/sparql
    http://localhost:8890/DAV/
    http://www.w3.org/2002/07/owl#

    5 Rows. -- 90 msec.


--------------------
Diagnosis Procedures
--------------------

The Diagnosis Procedures are the first steps that a System Administrator has to take to locate the source of an error in a GE. Once the nature of the error is identified by these tests, the system admin can resort to more concrete and specific testing to pinpoint the exact point of error and a possible solution.

The resource load of the Repository-RI strongly depends on the number of concurrent requests received as well as on the free main memory and disk space:

* Mimimum available main memory: 1 GB
* Mimimum available hard disk space: 2 GB

Resource availability
=====================

State the amount of available resources in terms of RAM and hard disk that are necessary to have a healthy enabler. This means that bellow these thresholds the enabler is likely to experience problems or bad performance.

Resource consumption
====================

Resource consumption strongly depends on the load, especially on the number of concurrent requests.

The main memory consumption of the Tomcat application server should be between 48MB and 1024MB. These numbers can vary significantly if you use a different application server.

I/O flows
=========

The only expected I/O flow is of type HTTP or HTTPS, on ports defined in Apache Tomcat configuration files, inbound and outbound. Requests interactivity should be low.
