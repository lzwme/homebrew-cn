class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghfast.top/https://github.com/ElementsProject/lightning/releases/download/v26.06.2/clightning-v26.06.2.zip"
  sha256 "301d528446abea91a0d7748fe69cf3fad1bf88dfb133febf64caf7ca7de87102"
  license "MIT"
  revision 1
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "605a5619bb1a012eb8ca79c1b637282cf6a37dba6a5c779af36386356d0f28d8"
    sha256 arm64_sequoia: "0e79bb2ed198968bf33972879e7e50ef2e0a42e8de71ddc7b12c199ecc2d757f"
    sha256 arm64_sonoma:  "1f4fc3de84b57eb31c7d5fbb144b39c9b657fb19b9ee78f5d24879b2206844f5"
    sha256 sonoma:        "0b42c77973da8507f2dd51b16a1249b5393f93932246e90133da6125d8493a92"
    sha256 arm64_linux:   "c0dcf6f927d1197d252c4c8e980fde3413a6adbcc29890b40d257c9e1697b993"
    sha256 x86_64_linux:  "3ae1f92baefc21be4420b0973e848c7da34238f7bea4ca65cdf7dc84f39ea428"
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
  depends_on "uv" => :build
  depends_on "bitcoin"
  depends_on "libsodium"
  depends_on "sqlite"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["mako", "setuptools"]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/00/62/791b31e69ae182791ec67f04850f2f062716bbd205483d63a215f3e062d3/mako-1.3.12.tar.gz"
    sha256 "9f778e93289bd410bb35daadeb4fc66d95a746f0b75777b942088b7fd7af550a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # Fix `configure` to build on macOS
    # PR ref: https://github.com/ElementsProject/lightning/pull/9072
    inreplace "configure", "-Wl,--gc-sections -c $TMPCFILE", "-Wl,--gc-sections $TMPCFILE"

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