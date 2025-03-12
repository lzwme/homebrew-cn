class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https:github.comElementsProjectlightning"
  url "https:github.comElementsProjectlightningreleasesdownloadv25.02clightning-v25.02.zip"
  sha256 "d34706fc391103047f7ccbae2979a5d90022134c82e9395052a5c42db6c33d11"
  license "MIT"
  head "https:github.comElementsProjectlightning.git", branch: "master"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "be9c3ee38faf131c6d7c126d56836d5f3ccde084570cc05b5cf56468cb7fc654"
    sha256 arm64_sonoma:  "00fb478eeb22d34d5e33dbae828157b83b799e2a2b38e8914d01fcf198dca637"
    sha256 arm64_ventura: "ca3c9f32c93decb9e007c95efdc421ebbdaee4b1766e7efefc5ccf496d0a945f"
    sha256 sonoma:        "1b922f5184455ba135a5ddf27f1e8c3d67393dda6e153e6e93cf6051f8cdd1a8"
    sha256 ventura:       "f654e1cc81b09d28b1f97aa76738b3e0b6b744d3471b92023ccdc34dcdb85e74"
    sha256 x86_64_linux:  "df98949e07cd165f09994cada540a03e620f3f181bbaed6683e5803a3c008c0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => :build
  depends_on "rust" => :build
  depends_on "bitcoin"
  depends_on "libsodium"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python", since: :catalina
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "mako" do
    url "https:files.pythonhosted.orgpackages5fd98518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  # Configure script overwrites `PKG_CONFIG_PATH` on macOS
  # PR: https:github.comElementsProjectlightningpull8146
  patch do
    url "https:github.combotantonylightningcommitcca721a9f3c5a15f6792b0dc1941959dbd93ac2f.patch?full_index=1"
    sha256 "ee375b92de3d49f4bdf33acf2eb672b693f5806ee418a380e37f3a6a4047c91d"
  end

  def install
    rm_r(["externallibsodium", "externallowdown"])

    venv = virtualenv_create(buildpath"venv", "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root"bin"
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec"gnubin" if OS.mac?

    system ".configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    lightningd_output = shell_output("#{bin}lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end