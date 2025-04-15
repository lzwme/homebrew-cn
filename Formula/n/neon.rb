class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.34.1.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.34.1.tar.gz"
  sha256 "29a9a8ee1468e7224eb4e4deb4445ef9c56940b41d50941570aac78a6021d461"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5de7501547df3cecbfb02f33c5c9def5019a535102c4e0f0ff28e7e0af120f98"
    sha256 cellar: :any,                 arm64_sonoma:  "16eaf4da6e271a6cfe5070f38f67de0e9ee56b3f91259812515b53d343b6ae79"
    sha256 cellar: :any,                 arm64_ventura: "cf8a86addf7031af206cd21a2c71ee82b90324b7c6666c8b43c84730e0fa2310"
    sha256 cellar: :any,                 sonoma:        "787440fdcd863a783a269dc2aa055f09ce8b2b55e103dd85c771dfce68088f33"
    sha256 cellar: :any,                 ventura:       "e56872eae4e9d9cba27f623f1987f63c6580a462e12d0c04f6086ac81dedcacf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8e8666b749a2af298853938a6eb674e215241e71ed994c31ca32d2d0cc49644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95a2968ed5046c5668ccbbdb1d5a174bbf2e8f4bfbbe097217b1209d1ef90b43"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <ne_basic.h>

      int main(int argc, char **argv)
      {
          char data[] = "Example data.\\n";
          ne_session *sess;
          int ec = EXIT_SUCCESS;
          ne_sock_init();
          sess = ne_session_create("http", "localhost", #{port});
          if (ne_get(sess, "/foo/bar/baz", STDOUT_FILENO)) {
              fprintf(stderr, "nget: Request failed: %s\\n", ne_get_error(sess));
              ec = EXIT_FAILURE;
          }
          ne_session_destroy(sess);
          return ec;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/neon", "-L#{lib}", "-lneon", "-o", "test"

    fork do
      server = TCPServer.new port
      session = server.accept
      msg = session.gets
      response_body = "Hello world! Message: #{msg.strip}"
      content_length = response_body.bytesize

      session.puts "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n"
      session.puts response_body
      session.close
      server.close
    end

    sleep 1
    assert_match "Hello world! Message: GET /foo/bar/baz HTTP/1.1", shell_output("./test")
  end
end