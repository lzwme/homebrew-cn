class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https:wiki.shibboleth.netconfluencedisplayOpenSAMLHome"
  url "https:shibboleth.netdownloadsc++-opensaml3.2.1opensaml-3.2.1.tar.bz2"
  sha256 "b402a89a130adcb76869054b256429c1845339fe5c5226ee888686b6a026a337"
  license "Apache-2.0"
  revision 3

  livecheck do
    url "https:shibboleth.netdownloadsc++-opensamllatest"
    regex(href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aec01267b070c38a196b958beb011023329df39275a53057ced729988f79bef9"
    sha256 cellar: :any,                 arm64_sonoma:  "ba2f7799db26f1d8c8bac996a6a04bf4101754420cb4f1ee204a6fcf27b78a67"
    sha256 cellar: :any,                 arm64_ventura: "10959a9e892a8a25fd9a096b7c26a408d65aa3dbb4962ed7eebf4b913a241f6e"
    sha256 cellar: :any,                 sonoma:        "2d2ee794c304246ae82e2026aeaf0a3edcdf9c5a441972c23de37ae66b9fdcf2"
    sha256 cellar: :any,                 ventura:       "ef04ca7e4a39762fe7e1b4d95fd396b2a2905a4be3f0c60ba7fcd9073b677d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b92a1f9fad4621c89964b7896bfef571a526da048b8076779dccbb204b60f0"
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}samlsign 2>&1", 255)
  end
end