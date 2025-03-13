class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https:developers.yubico.comyubikey-manager"
  url "https:files.pythonhosted.orgpackagesbcb1f48a9d7a8fa9517f00976a77e8d2f3c266bcd2f5b6f5c700f7f6679afe79yubikey_manager-5.6.0.tar.gz"
  sha256 "c9b35a9619cbf5f97e09067563131ed4fb739bb571dcd0f7986c91c428b2e6d8"
  license "BSD-2-Clause"
  head "https:github.comYubicoyubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a8d4f5b141d8f77aee9a08417d7c20dd4b684ecaccff31505497cd2a5630715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "415a9c6798363213eb7905b4298779485d4c5bca0abf9633cf7f592a4af55fab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c413608f3efd7fb9c471b70f9f1d9188dc444888e799d1b00174e983b2ec0bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "495d3f52b82918e675681b935ed080120514211bb16543fb1391d75b846cff9f"
    sha256 cellar: :any_skip_relocation, ventura:       "9be283386b0834e98ba16badad690fc43848dd9ee7520b73a853a17945b5daf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "729f61c9f30b124e9f6f2b8e10ddd52cfd2b07f3ca16f6a838a321c7d4b3547f"
  end

  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "pcsc-lite"

  # pin pyscard to 2.0.8, upstream bug report, https:github.comLudovicRousseaupyscardissues169

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackages8391e31b08aa0045e86f0a59882528a07ae8e268cd50509abab1261bcdbc8b5ffido2-2.0.0b1.tar.gz"
    sha256 "5be55f9cb33b2b688c670b3f1c4099be2229b77db6736d52b2ff13342badc1c6"
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
    url "https:files.pythonhosted.orgpackages883b7fa1fe835e2e93fd6d7b52b2f95ae810cf5ba133e1845f726f5a992d62c2more-itertools-10.6.0.tar.gz"
    sha256 "2cd7fad1009c31cc9fb6a035108509e6547547a7a738374f10bd49a09eb3ee3b"
  end

  resource "pyscard" do
    url "https:files.pythonhosted.orgpackagesfe1973e8fc37356a4232f9a86acf3794a0f6d8e014430f1f88153ae19fc21d88pyscard-2.2.1.tar.gz"
    sha256 "920e688a5108224cb19b915c3fd7ea7cf3d1aa379587ffd087973e84c13f8d94"
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