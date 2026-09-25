class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.144.zip"
  sha256 "b981818fbbd4bf9f6f4feac03136800f6e16a7d0b7515924ff7a2661ca26e581"
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
    rebuild 1
    sha256 arm64_golden_gate: "1ebfc73f68fd8b605fc534a7d553c9d0d7ec259c40af6a586dd6cbdbb9f38567"
    sha256 arm64_tahoe:       "ab7d9c9430423bc601ea9e5678ea3096da984d6c10fd36817a4ad40ae136038d"
    sha256 arm64_sequoia:     "dc6b37c1318b6e72b4df10cd1fb1501ffe5f621dd495f85b2e92fcaffd1cf9e9"
    sha256 arm64_linux:       "56dbcbbcd995345656af0c704fd01aa220b7c5428e8b6247fe6053f97eff372e"
    sha256 x86_64_linux:      "152b38e9e29792155f6453e21ba26e835ae369673dfff0f7dbdb1786552f7dac"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system bin/"soapcpp2", "calc.h"
    assert_path_exists testpath/"calc.add.req.xml"
  end
end