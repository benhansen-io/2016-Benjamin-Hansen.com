jekyll build
ssh server rm -r /srv/http/benjamin-hansen/blog/
scp -r _site server:/srv/http/benjamin-hansen/blog/
