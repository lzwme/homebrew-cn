class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghfast.top/https://github.com/ElementsProject/lightning/releases/download/v26.06/clightning-v26.06.zip"
  sha256 "39de07cf5e28e2a4fcbcdff36899d9379709d5533ddb6889b16d93662b5a8d6f"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "9126d042eeeafc470919f99d2e193cb0a7e4f427cc210dba9e1b30b241a3ea32"
    sha256 arm64_sequoia: "62916b8c0542d5426af3f7c2829a61ac76eb6b39c32822daabf26c7763fddde8"
    sha256 arm64_sonoma:  "50afb9f20c8f41a07e8d3e05e0f073beef735699f58ce0fe7914bb5d71448b3f"
    sha256 sonoma:        "45b848dcdf84a410c33e89ff57119eb84319281fab196a4cf869d20727764290"
    sha256 arm64_linux:   "1210b1af987ba83c1c8271419421272986bb8a78a8af33aa96b1c15c063ec84c"
    sha256 x86_64_linux:  "7c0c3da227c1e28b8692d0f7634ba82ad2671816a9b08388c89f73c36b8cbdf1"
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
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
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