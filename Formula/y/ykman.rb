class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https:developers.yubico.comyubikey-manager"
  url "https:files.pythonhosted.orgpackagesd1e27037a16f72d10939384744366f3797cc3052fc726a7bd001f9ed28bfe1c9yubikey_manager-5.7.0.tar.gz"
  sha256 "9a69212ac32ed82a78a287417d0cf476043388c28f84c356a8196f0f5c29a830"
  license "BSD-2-Clause"
  head "https:github.comYubicoyubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2db45fdd68c86836c0f2936835e11e5d1385a162d0dff027ce0b56a6630a730f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e101b01d362b695d1818a81c95c5d8fdcdd5170b6e490bc5e1bdfca23a817ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1de046d5180a223cff87dd1a67211404717d9ba6a864bcf1503009dfc37883f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f454774ff7aeaba4ebd20bba5c37998600ad872e3d67db713f689b07b17103aa"
    sha256 cellar: :any_skip_relocation, ventura:       "7febcee7110dd53648ec23859fa376832fb8d343178c74bc3d01c92d5e1e9c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79d978ddcc94eb3c65b409f9be4c9b1122372dc412e9931a654ee7109cfd8801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbcf19200208c02459ed0c763124dc7c986215b37cb45338c01026bbeddab301"
  end

  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "pcsc-lite"

  # pin pyscard to 2.0.8, upstream bug report, https:github.comLudovicRousseaupyscardissues169

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackages8db96ec8d8ec5715efc6ae39e8694bd48d57c189906f0628558f56688d0447b2fido2-2.0.0.tar.gz"
    sha256 "3061cd05e73b3a0ef6afc3b803d57c826aa2d6a9732d16abd7277361f58e7964"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesdfadf3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackages7b6f357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0cjeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages7009d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37dkeyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "pyscard" do
    url "https:files.pythonhosted.orgpackages2417a52a6ceb0a58afc1c8b9274bd9fff8ac971a7d5ee886bf31297768a88aa0pyscard-2.2.2.tar.gz"
    sha256 "c77481fb86f4a17bc441d7b36551c1d36a9d3a48c4bb30ab8118886e6f275081"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  def install
    # Fixes: smartcardscardhelpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}PCSC" if OS.linux?

    venv = virtualenv_install_with_resources without: "pyscard"
    # Use brewed swig
    # https:github.comHomebrewhomebrew-corepull176069#issuecomment-2200583084
    # https:github.comLudovicRousseaupyscardissues169#issuecomment-2200632337
    resource("pyscard").stage do
      inreplace "pyproject.toml", 'requires = ["setuptools","swig"]', 'requires = ["setuptools"]'
      venv.pip_install Pathname.pwd
    end

    man1.install "manykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ykman --version")
  end
end