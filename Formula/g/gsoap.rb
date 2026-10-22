class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.145.zip"
  sha256 "176767e2443f3586048108209d9424a71b0ae7ba2658655878ab513edec1eede"
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
    sha256 arm64_golden_gate: "ed6c8e53cc2a24d72eb625698a67313e839be49f68de9b456f4172ed04c647af"
    sha256 arm64_tahoe:       "c470c69c6c5823a4e740bfe32fba89fdbb78865e981ac989635886148fdf014a"
    sha256 arm64_sequoia:     "0fa9a240ad4441ec373f28a74f2ddb40d3655c92cc73b62bd3c9dffbdacf00a9"
    sha256 arm64_linux:       "8697ce03d6bd41763ea93987a93b0c3a1bbf055ee570a3fc1e4f003adfae5b17"
    sha256 x86_64_linux:      "58146108cd5d8935dc1c8d2efa3c8523b49072b758e889f92ba1dcb08b32632e"
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