class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://ghproxy.com/https://github.com/obgm/libcoap/archive/v4.3.2.tar.gz"
  sha256 "ada0eefb5bc5a3cd7099cf44f3bf5f0214d1f83fcb5c1690a09cbb40f8e309c5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56bc8c3f7f6c8efb9cf34940134a115b0388cb558467a375d792765069421ccf"
    sha256 cellar: :any,                 arm64_monterey: "efa59e578a537930bcd40d74a7ddda2c738b16c9bf99fad8bf35b23495021a23"
    sha256 cellar: :any,                 arm64_big_sur:  "b4c2a7cd7ea91dc4cbe1aae159e070912ba3ca6b95a4304c101542f7d8f00c0a"
    sha256 cellar: :any,                 ventura:        "c1e1cac76bb7a2aad36d84934ef2a8f16dc6b783c54f58f80f62954bcf950920"
    sha256 cellar: :any,                 monterey:       "d20f28a35e47756c5c4c6794dcfbc10230036dd41434fd3f2fc27e040434668a"
    sha256 cellar: :any,                 big_sur:        "ba7ddf2bd7e6ab994bca39331dc4ff7498000dfe33dd515a3813be8f54ea9697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81d01d515270b8c7e07800d92b4168240c4d10a52da69f8bd3895d2a09d690a6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-manpages"
    system "make"
    system "make", "install"
  end

  test do
    %w[coap-client coap-server].each do |src|
      system ENV.cc, pkgshare/"examples/#{src}.c",
        "-I#{Formula["openssl@3"].opt_include}", "-I#{include}",
        "-L#{Formula["openssl@3"].opt_lib}", "-L#{lib}",
        "-lcrypto", "-lssl", "-lcoap-3-openssl", "-o", src
    end

    port = free_port
    fork do
      exec testpath/"coap-server", "-p", port.to_s
    end

    sleep 1
    output = shell_output(testpath/"coap-client -B 5 -m get coap://localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end