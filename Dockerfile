FROM postgres:15

# 选用国内镜像源以提高下载速度
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

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
