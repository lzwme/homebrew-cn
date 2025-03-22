class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.137.zip"
  sha256 "a6c9fb9088efd60ad0e983fa83d8440fe128514db22297b5b3f2de302106e55c"
  # Parts of the software are alternatively licensed under gSOAP-1.3b, but this
  # license is considered non-free by Debian and Fedora due to section 3.2:
  #
  # 3.2. Availability of Source Code.
  # Any Modification created by You will be provided to the Initial Developer in
  # Source Code form and are subject to the terms of the License.
  #
  # Ref: https://salsa.debian.org/ellert/gsoap/-/blob/master/debian/copyright#L7-26
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_sequoia: "bb7af3708c837df04b0d85ca011704aff0bc6bb9c2a348da075e597cc79d3029"
    sha256 arm64_sonoma:  "45c165b01549c53d9b3a42c287d2bbbfb0defc4d9e7a0c8dba32f55382ef799b"
    sha256 arm64_ventura: "1038dfb1538c1399173a1715580d953e93dddc63754d8f81c1a79aab7f92c0cd"
    sha256 sonoma:        "eae787dcec83783763dd5cc6c633f1d9d56be6d2a325d8fbdc97e64d9a09d2c9"
    sha256 ventura:       "855ef14eb96ed5ec7c79db316bd770754e7859c17e7b337fd58d5f432d5e2dc1"
    sha256 arm64_linux:   "2cd0b451884476fe55bcf35f494daebffafbbcb4724d0ef9ef04d8476b718c1e"
    sha256 x86_64_linux:  "d11ba7ecab226c3e909d1dcc936fcac801065afc87a3d9f98c75bac3feb88f3d"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system bin/"soapcpp2", "calc.h"
    assert_path_exists testpath/"calc.add.req.xml"
  end
end