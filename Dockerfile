FROM postgres:15

# 选用国内镜像源以提高下载速度
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories \
&& apk add --update --no-cache python3 py3-pip \
&& rm -rf /var/cache/apk/*

COPY . /tmp/pgvector

RUN apt-get update && \
		apt-get install -y --no-install-recommends build-essential postgresql-server-dev-15 && \
		cd /tmp/pgvector && \
		make clean && \
		make OPTFLAGS="" && \
		make install && \
		mkdir /usr/share/doc/pgvector && \
		cp LICENSE README.md /usr/share/doc/pgvector && \
		rm -r /tmp/pgvector && \
		apt-get remove -y build-essential postgresql-server-dev-15 && \
		apt-get autoremove -y && \
		rm -rf /var/lib/apt/lists/*
