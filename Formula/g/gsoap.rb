class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.140.zip"
  sha256 "46a2a91f1d9fd756fd6e6e3b82deb673e3f7cc574d234c91132cfaf90449d3ab"
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
    sha256 arm64_tahoe:   "6c739ac36f28de1fc1812180366b62390c42e052327e8d93ab8af48771cde30a"
    sha256 arm64_sequoia: "ae5d6df77c192f25b3355c3a4eac1e050a16179280e966ce3cdbdba426266616"
    sha256 arm64_sonoma:  "cf6862c8713cac19574dc7f2febe5a48d45ea0147bda430ec8010088e0e33cf4"
    sha256 sonoma:        "0234e78f4af32c7d6a8ee340d4252a1f9f103818043d637c1c0554a4764fdbc4"
    sha256 arm64_linux:   "b73174a77d8e7c20da8f9a0855fafc5a6035ecd004c93517768cbde20611f022"
    sha256 x86_64_linux:  "727201e9877c157cbbfd7a5b3158b22ae97f1e9abac71a0b5c885c69d905295c"
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