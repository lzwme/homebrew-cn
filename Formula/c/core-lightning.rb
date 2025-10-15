class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghfast.top/https://github.com/ElementsProject/lightning/releases/download/v25.09/clightning-v25.09.zip"
  sha256 "a97f44647b83b44718094f1838c6c74e8dc90c0009f2773a37b17ff80004a67e"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "acf72d46243f92547a60ae133be2e70f09351c15fd127bde71845508f17f9b4b"
    sha256 arm64_sequoia: "575a43de7fd78adcb332b6af3661d5f6900d8da1cfa141edff59612cad7da36a"
    sha256 arm64_sonoma:  "7ebf05047d584acf509a56eaedd4bb935ab0eacc4b6bbc3d063aaebdadaa1890"
    sha256 sonoma:        "753d6d32cd9c49dbcdaed157995cc74a23ecc18759a47febd55a22bf0f04526f"
    sha256 arm64_linux:   "2275d43614ce5b224eeb4585ef86840071cb7d4c3e23bd5dc102155ebbb96018"
    sha256 x86_64_linux:  "9ccf024030268817ef76beb29f4079e3ff7f42af1f9a4d190c77f5f721143f01"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "bitcoin"
  depends_on "libsodium"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  # Configure script overwrites `PKG_CONFIG_PATH` on macOS
  # PR: https://github.com/ElementsProject/lightning/pull/8146
  patch do
    url "https://github.com/botantony/lightning/commit/cca721a9f3c5a15f6792b0dc1941959dbd93ac2f.patch?full_index=1"
    sha256 "ee375b92de3d49f4bdf33acf2eb672b693f5806ee418a380e37f3a6a4047c91d"
  end

  def install
    rm_r(["external/libsodium", "external/lowdown"])

    venv = virtualenv_create(buildpath/"venv", "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    rm_r Dir["#{bin}/*.dSYM"]
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end