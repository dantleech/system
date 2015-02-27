# /etc/varnish/default.vcl
vcl 4.0;

acl invalidators {
    "localhost";
}

backend default {
    .host = "127.0.0.1";
    .port = "8000";
}

sub vcl_recv {
    #if (req.url ~ "^/admin") {
    #    unset req.http.cookie;
    #    unset req.http.cache-control;
    #}

    if (req.method == "PURGE") {
        if (!client.ip ~ invalidators) {
            return (synth(405, "Not allowed"));
        }
        return (purge);
    }

    if (req.method == "BAN") {
        if (!client.ip ~ invalidators) {
            return (synth(405, "Not allowed"));
        }


        if (req.http.x-cache-tags) {
            ban("obj.http.x-host ~ " + req.http.x-host
                + " && obj.http.x-url ~ " + req.http.x-url
                + " && obj.http.content-type ~ " + req.http.x-content-type
                + " && obj.http.x-cache-tags ~ " + req.http.x-cache-tags
            );
        } else {
            ban("obj.http.x-host ~ " + req.http.x-host
                + " && obj.http.x-url ~ " + req.http.x-url
                + " && obj.http.content-type ~ " + req.http.x-content-type
            );
        }

        return (synth(200, "Banned"));
    }
}

sub vcl_backend_response {
    unset beresp.http.set-cookie;

    # Set ban-lurker friendly custom headers
    set beresp.http.x-url = bereq.url;
    set beresp.http.x-host = bereq.http.host;
}

sub vcl_deliver {

    if (!resp.http.x-cache-debug) {
        unset resp.http.x-url;
        unset resp.http.x-host;
    }

    if (obj.hits > 0) {
        set resp.http.X-Cache = "HIT";
    } else {
        set resp.http.X-Cache = "MISS";
    }
}
