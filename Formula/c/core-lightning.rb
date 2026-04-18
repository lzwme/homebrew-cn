class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://ghfast.top/https://github.com/ElementsProject/lightning/releases/download/v25.09.3/clightning-v25.09.3.zip"
  sha256 "d051a08f1432ddc7b26d1132ea9ad302de935f89a5a930eafcf92f68830649ab"
  license "MIT"
  revision 1
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "fa345f8d4113ff7e9d2d37b208040770047fc7d5e03d34aa822ee81b11c3ff09"
    sha256 arm64_sequoia: "b49a2b4eaf6b52fefac0a15adec0b0dac8a079f0fe03442276c9ad98d7d3335e"
    sha256 arm64_sonoma:  "f3c220075efa013f1b8bc09817b469af61e2b22aab38dc1cdab93eb8be3bb56a"
    sha256 sonoma:        "343b50d84398893ad430b50844db6192b980aaf74318cfca6803a4843bce9485"
    sha256 arm64_linux:   "b25ab15a2b6cd7cb53c3ba45798a11ac47507a46ab3045573f39bbda3dbb6963"
    sha256 x86_64_linux:  "4ca16b767391a2118693916b646f9d2e8fdbdb58a53802dd6c8246b5d3439d9a"
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

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["mako", "setuptools"]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/59/8a/805404d0c0b9f3d7a326475ca008db57aea9c5c9f2e1e39ed0faa335571c/mako-1.3.11.tar.gz"
    sha256 "071eb4ab4c5010443152255d77db7faa6ce5916f35226eb02dc34479b6858069"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
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