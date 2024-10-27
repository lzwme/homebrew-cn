class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.33.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.33.0.tar.gz"
  sha256 "659a5cc9cea05e6e7864094f1e13a77abbbdbab452f04d751a8c16a9447cf4b8"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9345dbd1130b12eb313abbf4eed7847f7bb168c64d298724a581bf79a3072958"
    sha256 cellar: :any,                 arm64_sonoma:   "be01606755aebe2d112fd9c80b0c97f6e38531cd1a4ff31d05d34b1782f753ef"
    sha256 cellar: :any,                 arm64_ventura:  "2e2d1da206b150e739857c21e678cda43dad1ec15128855463b6ede037eceebc"
    sha256 cellar: :any,                 arm64_monterey: "ef89b353ac8769c92b529d205ac989bc15ab7c30bf94ec210dd16f6234375bfd"
    sha256 cellar: :any,                 sonoma:         "4b553d123301b00b5ab10dcc999918f6461bb2fa06e68b9aa4740e98cc86b981"
    sha256 cellar: :any,                 ventura:        "d8f6c8e59aa1a93fb4b747d941943cbc9e94e69ca9ae44377568d98fdefe6c80"
    sha256 cellar: :any,                 monterey:       "64c5600a5ff568b5d38c1eb8715473b48a0c62fd3ca5dfa625dbf51154029bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50173d7d57cdaf7b97212155ce200dda9d9a3ce22935d83cb2212404b9e6a29d"
  end

  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}"
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
      session.puts "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n"
      session.puts "Hello world! Message: #{msg}"
      session.close
      server.close
    end

    sleep 1
    assert_match "Hello world! Message: GET /foo/bar/baz HTTP/1.1\r\n", shell_output("./test")
  end
end