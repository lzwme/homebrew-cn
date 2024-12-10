class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https:github.comElementsProjectlightning"
  url "https:github.comElementsProjectlightningreleasesdownloadv24.11clightning-v24.11.zip"
  sha256 "3164f3527e6408132beaee64dea0fb6d566377b77e0be67a2359e80dcbd7ba9e"
  license "MIT"

  livecheck do
    url :stable
    regex(^v(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "e55d844454993325282420ee4ac5677118c037b3e21fdc2316bbb4cec7ad2c06"
    sha256 arm64_sonoma:  "e0edaff0f78ef379035eb432a76133ba9ff7aadb83f915a93bd48cc0d64e6d89"
    sha256 arm64_ventura: "398e40d27468a31cdce9ded4c1ccdcb4748ad21c6eefc7765fba98120579149d"
    sha256 sonoma:        "a99d79cde0b5a92456cb079a08b34a57a5dd22eac04800ff3f25e0a2eff19f97"
    sha256 ventura:       "b7ad63a884466f6ef581296587a73f61392a259c3fd1ecffe9818ef95433ca30"
    sha256 x86_64_linux:  "1ccc0cc7f832cf482a1d84748825d1b5fdce4096ae51d7ac6746e3a32358ff10"
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
    url "https:files.pythonhosted.orgpackages5fd98518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages4354292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
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