class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.37.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.37.0.tar.gz"
  sha256 "9358cf29e11127b1a3196621d07159d3b013a0b79ebc388a25488a51443b8b81"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c13455e41cec857d37b5694facce12480f5e8640af9c09ba5c8233fa2a6f7902"
    sha256 cellar: :any,                 arm64_sequoia: "fda6ce8a77530afd41a9630db2946645f76bc777c3273f55ac05ff0dd5456e78"
    sha256 cellar: :any,                 arm64_sonoma:  "e064408f35e3be5d16302e1a4a9130ed27bf5a76a046b54df3f12482442f4527"
    sha256 cellar: :any,                 sonoma:        "40eebc8ea0f2265fdec954b7c084e941a987dc7461671fab43cd54cff1a69d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44aeeff65f81018f7112e859eeed4f8b3f96d77093398967b817fab4200367a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0b63351daff119266643ef63d4e185fd55388984f3118ca19bfa878db22a3f"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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