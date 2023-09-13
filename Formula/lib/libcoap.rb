class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://ghproxy.com/https://github.com/obgm/libcoap/archive/v4.3.3.tar.gz"
  sha256 "790a657daa98f942560859b432de7672a0ac5ff171d861ba7fc997d793e1a2c8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f0a4b5bfb7167e42c73ab56b1420ffe70106a46582eba3ab639cb71c7514bdcc"
    sha256 cellar: :any,                 arm64_monterey: "b5681b016f932be8c9adf1a1b6b6232c00185bd3ee22348e19a914e087c88a14"
    sha256 cellar: :any,                 arm64_big_sur:  "ae20f5a9b46bfdde22bf1bd01b41539815ca2ab96d93416c77b78f6ad4d5c079"
    sha256 cellar: :any,                 ventura:        "6dd0cec93ce11f4e41c1681b09bf0c526ace9b56a4fb3dc48651b688e3b8895d"
    sha256 cellar: :any,                 monterey:       "cee4b37b76662376290f97e5cd8385393c75633953e82ac493c9ab538b5c8db8"
    sha256 cellar: :any,                 big_sur:        "3d2110aeb7c6961cee20fe8cd66184c6b63a08e8ddba34cef37720ac49aff192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4573838ac7365af81891b8258bc9651de621d2ce3b23ea95f05ba39ce894261"
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