# docker build --no-cache --progress=plain -t okd_io .
# docker run --rm -it -p 80:80 okd_io 

FROM registry.fedoraproject.org/fedora:38 as builder
RUN bash -c "dnf install -y python3-pip git"
COPY . /usr/src/okd.io
RUN bash -c "cd /usr/src/okd.io && pip install -r requirements.txt && ./build.sh"

FROM registry.fedoraproject.org/fedora:38
RUN bash -c "dnf install -y httpd"
COPY --from=builder /usr/src/okd.io/public /var/www/html/
EXPOSE 80
CMD ["httpd", "-DFOREGROUND"]
