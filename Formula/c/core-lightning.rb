class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https:github.comElementsProjectlightning"
  url "https:github.comElementsProjectlightningreleasesdownloadv24.08.1clightning-v24.08.1.zip"
  sha256 "d992af84dbb319fb4ac127663241cec04f54108e44c27e471d2cb2654702c01e"
  license "MIT"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "04269112db447906dd83ca753457bbb1ca517240ca3718c820abe1b0c88e9687"
    sha256 arm64_sonoma:  "feb6e52f2c205eef80dca8f8e4bd9692f79deb63031da27cad6f974c3623826a"
    sha256 arm64_ventura: "a11b53f72b183ada47d1a9ef6d175477d68d4a267694845c7a847317e18407bb"
    sha256 sonoma:        "002da19820ec43df4a29edd5dcd8dfdba8ffa0a4f43a0f255652642fc5c82687"
    sha256 ventura:       "ab6afa0566a63b50cf01cbb731246e1497fcda7569a01d14bbc15504e67d56ab"
    sha256 x86_64_linux:  "ac8e18f4c0626cfcb1fc485038a6f9e96e54dd3d03d559cb0780ffc90eae1301"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
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
    url "https:files.pythonhosted.orgpackagesfa0b29bc5a230948bf209d3ed3165006d257e547c02c3c2a96f6286320dfe8dcmako-1.3.6.tar.gz"
    sha256 "9ec3a1583713479fae654f83ed9fa8c9a4c16b7bb0daba0e6bbebff50c0d983d"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  # Backport fix for paths on ARM macOS
  # PR ref: https:github.comElementsProjectlightningpull7857
  patch do
    url "https:github.comElementsProjectlightningcommit94c5695d6f1933aa8bffe50180dde702f1485297.patch?full_index=1"
    sha256 "60742fa3911e4c9599cb9f0c0190fb7ed9940dba020236c8005311f1456bb4db"
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