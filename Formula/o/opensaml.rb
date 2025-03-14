class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.1/opensaml-3.3.1.tar.bz2"
  sha256 "d8e24e070fc6bb80682632ca32c8569a9f3ef170ba57e3b82818322e75b6a37e"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "424750ca3b4b621fc165bd65c1fa43bf8380b1e2edc02e54a69c8c0d0a362848"
    sha256 cellar: :any,                 arm64_sonoma:  "598d3f098f2019a58c6eb7e0209166386ba5b95aa2c65fbe295efefd1667004b"
    sha256 cellar: :any,                 arm64_ventura: "8cb5d53e9ce9c54089927ec316df7ffe533fef191704f7f32af88ae09010689e"
    sha256 cellar: :any,                 sonoma:        "5d4e1be03c528a97e4e4ac17af63b712a61022c8fd26d2abd83f65732dc66b41"
    sha256 cellar: :any,                 ventura:       "024e4168fb0530e8b68440549a53534c99b0943d5ef1278012c816ec8a766660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21dc02829bae8f62f56be0d9c0456fd804ba004bf41c13ad16ca0f534a759e80"
  end

  depends_on "pkgconf" => :build
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end