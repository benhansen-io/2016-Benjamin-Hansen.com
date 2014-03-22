ssh server <<STOP
if [ ! -d /srv/http/benjamin-hansen-staging/blog ]; then
    echo "Staging does not exist. Quitting.";
    exit;
fi
rm -r /srv/http/benjamin-hansen-staging/blog-old/;
mv /srv/http/benjamin-hansen/blog /srv/http/benjamin-hansen-staging/blog-old;
mv /srv/http/benjamin-hansen-staging/blog /srv/http/benjamin-hansen/blog;
STOP
