# use this to deploy to your test server
# run `fab deploy`

from fabric.api import run, env, cd, sudo

env.hosts = ['profero@proferochina.com'] #account@server

def deploy():

	# Pull code from Github
	with cd('/var/www/<%= _.slugify(sitename) %>'): #/path/to/project
		sudo('git pull origin staging') #staging = test branch