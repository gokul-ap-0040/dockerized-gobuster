function generate_wordlist() {
   git clone -q https://$GIT_USERNAME:$GIT_PASSWORD@github.com/shopuptech/$2 > /dev/null
   cd $2
   git ls-files > ../$2-wordlist.txt
   cd ..
   rm -rf $2
}

function bruteforce() {
   gobuster dir -r -q -e -u $1 -t 80 -w $2-wordlist.txt -s 200 -b "" > $2-o1.txt 2>&1
   printf "\n[+] Exposed Files :\n\n"
   cat $2-o1.txt | cut -d " " -f1 > $2-o2.txt 2>&1
   rm $2-o1.txt
}

function filter_results() {
   cat $1-o2.txt | grep -v '\.\(php\|js\|html\|png\|jpg\|jpeg\|css\|ttf\|gif\|eot\|z\|htm\|docx\|pdf\|woff2\|eot\|svg\|doc\|htm\|woff\|txt\|ico\|fdf\|eps\|icc\|ai\|md\|p12\|otf\|swf\|TXT\|inv\|crt\|psd\|ufm\|afm\|map\|ser\|rst\|ts\|tsx\|lock\)$' | tee $1-output.txt 

}

url=$1 # url
repo_url=$2 # repo url

repo=$(echo $repo_url | cut -d "/" -f5)

################################

generate_wordlist $repo_url $repo
bruteforce $url $repo
filter_results $repo
