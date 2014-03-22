jekyll build
ssh server rm -r /srv/http/benjamin-hansen-staging/blog/
scp -r _site server:/srv/http/benjamin-hansen-staging/blog/
