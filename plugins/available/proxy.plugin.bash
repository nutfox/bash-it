cite about-plugin
about-plugin 'Proxy Tools'

disable_proxy ()
{
	about 'Disables proxy settings for Bash, npm and SSH'
	group 'proxy'

	unset http_proxy
	unset https_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset ALL_PROXY
	unset no_proxy
	unset NO_PROXY
	echo "Disabled proxy environment variables"

	npm_disable_proxy
	ssh_disable_proxy
}

enable_proxy ()
{
	about 'Enables proxy settings for Bash, npm and SSH'
	group 'proxy'

	export http_proxy=$BASH_IT_HTTP_PROXY
	export https_proxy=$BASH_IT_HTTPS_PROXY
	export HTTP_PROXY=$http_proxy
	export HTTPS_PROXY=$https_proxy
	export ALL_PROXY=$http_proxy
	export no_proxy=$BASH_IT_NO_PROXY
	export NO_PROXY=$no_proxy
	echo "Enabled proxy environment variables"

	npm_enable_proxy
	ssh_enable_proxy
}

enable_proxy_alt ()
{
	about 'Enables alternate proxy settings for Bash, npm and SSH'
	group 'proxy'

	export http_proxy=$BASH_IT_HTTP_PROXY_ALT
	export https_proxy=$BASH_IT_HTTPS_PROXY_ALT
	export HTTP_PROXY=$http_proxy
	export HTTPS_PROXY=$https_proxy
	export ALL_PROXY=$http_proxy
	export no_proxy=$BASH_IT_NO_PROXY
	export NO_PROXY=$no_proxy
	echo "Enabled alternate proxy environment variables"

	npm_enable_proxy $http_proxy $https_proxy
	ssh_enable_proxy
}

show_proxy ()
{
	about 'Shows the proxy settings for Bash, Git, npm and SSH'
	group 'proxy'

	echo ""
	echo "Environment Variables"
	echo "====================="
	env | grep -i "proxy"

	bash_it_show_proxy
	npm_show_proxy
	git_global_show_proxy
	ssh_show_proxy
}

proxy_help ()
{
	about 'Provides an overview of the bash-it proxy configuration'
	group 'proxy'

	echo ""
	echo "bash-it uses the variables BASH_IT_HTTP_PROXY and BASH_IT_HTTPS_PROXY to set the shell's"
	echo "proxy settings when you call 'enable_proxy'. These variables are best defined in a custom"
	echo "script in bash-it's custom script folder ($BASH_IT/custom),"
	echo "e.g. $BASH_IT/custom/proxy.env.bash"
	echo "You can also define a comma-separated list of proxy exclusions using BASH_IT_NO_PROXY."

	bash_it_show_proxy
}

bash_it_show_proxy ()
{
	about 'Shows the bash-it proxy settings'
	group 'proxy'

	echo ""
	echo "bash-it Environment Variables"
	echo "============================="
	echo "(These variables will be used to set the proxy when you call 'enable_proxy')"
	echo ""
	env | grep -e "BASH_IT.*PROXY"
}

npm_show_proxy ()
{
	about 'Shows the npm proxy settings'
	group 'proxy'

	if $(command -v npm &> /dev/null) ; then
		echo ""
		echo "npm"
		echo "==="
		echo "npm HTTP  proxy: " `npm config get proxy`
		echo "npm HTTPS proxy: " `npm config get https-proxy`
	fi
}

npm_disable_proxy ()
{
	about 'Disables npm proxy settings'
	group 'proxy'

	if $(command -v npm &> /dev/null) ; then
		npm config delete proxy
		npm config delete https-proxy
		echo "Disabled npm proxy settings"
	fi
}

npm_enable_proxy ()
{
	about 'Enables npm proxy settings'
	group 'proxy'

	local my_http_proxy=${1:-$BASH_IT_HTTP_PROXY}
	local my_https_proxy=${2:-$BASH_IT_HTTPS_PROXY}

	if $(command -v npm &> /dev/null) ; then
		npm config set proxy $my_http_proxy
		npm config set https-proxy $my_https_proxy
		echo "Enabled npm proxy settings"
	fi
}

git_global_show_proxy ()
{
	about 'Shows global Git proxy settings'
	group 'proxy'

	if $(command -v git &> /dev/null) ; then
		echo ""
		echo "Git (Global Settings)"
		echo "====================="
		echo "Git (Global) HTTP  proxy: " `git config --global --get http.proxy`
		echo "Git (Global) HTTPS proxy: " `git config --global --get https.proxy`
	fi
}

git_global_disable_proxy ()
{
	about 'Disables global Git proxy settings'
	group 'proxy'

	if $(command -v git &> /dev/null) ; then
		git config --global --unset-all http.proxy
		git config --global --unset-all https.proxy
		echo "Disabled global Git proxy settings"
	fi
}

git_global_enable_proxy ()
{
	about 'Enables global Git proxy settings'
	group 'proxy'

	if $(command -v git &> /dev/null) ; then
		git_global_disable_proxy

		git config --global --add http.proxy $BASH_IT_HTTP_PROXY
		git config --global --add https.proxy $BASH_IT_HTTPS_PROXY
		echo "Enabled global Git proxy settings"
	fi
}

git_show_proxy ()
{
	about 'Shows current Git project proxy settings'
	group 'proxy'

	if $(command -v git &> /dev/null) ; then
		echo "Git Project Proxy Settings"
		echo "====================="
		echo "Git HTTP  proxy: " `git config --get http.proxy`
		echo "Git HTTPS proxy: " `git config --get https.proxy`
	fi
}

git_disable_proxy ()
{
	about 'Disables current Git project proxy settings'
	group 'proxy'

	if $(command -v git &> /dev/null) ; then
		git config --unset-all http.proxy
		git config --unset-all https.proxy
		echo "Disabled Git project proxy settings"
	fi
}

git_enable_proxy ()
{
	about 'Enables current Git project proxy settings'
	group 'proxy'

	if $(command -v git &> /dev/null) ; then
		git_disable_proxy

		git config --add http.proxy $BASH_IT_HTTP_PROXY
		git config --add https.proxy $BASH_IT_HTTPS_PROXY
		echo "Enabled Git project proxy settings"
	fi
}


svn_show_proxy ()
{
	about 'Shows current SVN project proxy settings'
	group 'proxy'

	if $(command -v svn &> /dev/null) ; then
		echo "SVN Project Proxy Settings"
		echo "====================="
		echo "SVN HTTP  proxy: " `git config --get http.proxy`
		echo "SVN HTTPS proxy: " `git config --get https.proxy`
	fi
}

svn_disable_proxy ()
{
	about 'Disables current SVN project proxy settings'
	group 'proxy'

	if $(command -v svn &> /dev/null) ; then
		#git config --unset-all http.proxy
		#git config --unset-all https.proxy
		echo "Disabled SVN project proxy settings"
	fi
}

svn_enable_proxy ()
{
	about 'Enables current SVN project proxy settings'
	group 'proxy'

	if $(command -v svn &> /dev/null) ; then
		svn_disable_proxy

		#git config --add http.proxy $BASH_IT_HTTP_PROXY
		#git config --add https.proxy $BASH_IT_HTTPS_PROXY
		echo "Enabled SVN project proxy settings"
	fi
}

ssh_show_proxy ()
{
	about 'Shows SSH config proxy settings (from ~/.ssh/config)'
	group 'proxy'

	if [ -f ~/.ssh/config ] ; then
		echo ""
		echo "SSH Config Enabled in ~/.ssh/config"
		echo "==================================="
		awk '
		    $1 == "Host" {
		        host = $2;
		        next;
		    }
		    $1 == "ProxyCommand" {
		        $1 = "";
		        printf "%s\t%s\n", host, $0
		    }
		' ~/.ssh/config | column -t

		echo ""
		echo "SSH Config Disabled in ~/.ssh/config"
		echo "===================================="
		awk '
		    $1 == "Host" {
		        host = $2;
		        next;
		    }
		    $0 ~ "^#.*ProxyCommand.*" {
		        $1 = "";
		        $2 = "";
		        printf "%s\t%s\n", host, $0
		    }
		' ~/.ssh/config | column -t
	fi
}

ssh_disable_proxy ()
{
	about 'Disables SSH config proxy settings'
	group 'proxy'

	if [ -f ~/.ssh/config ] ; then
		sed -e's/^.*ProxyCommand/#	ProxyCommand/' -i ""  ~/.ssh/config
		echo "Disabled SSH config proxy settings"
	fi
}


ssh_enable_proxy ()
{
	about 'Enables SSH config proxy settings'
	group 'proxy'

	if [ -f ~/.ssh/config ] ; then
		sed -e's/#	ProxyCommand/	ProxyCommand/' -i ""  ~/.ssh/config
		echo "Enabled SSH config proxy settings"
	fi
}
