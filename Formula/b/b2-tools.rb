class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https:github.comBackblazeB2_Command_Line_Tool"
  url "https:files.pythonhosted.orgpackages5f4ff5bb965f9a1051ba1918061be414f262f1c4be3bcf8551e1cba59bcf1406b2-3.19.0.tar.gz"
  sha256 "5da4f79573b9e1e027f1bf1ecea2b1adb2f345e0511e00970255ce7f400eba37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6354c39be5cdfa26ee563fecb997f57a722481421308951d783ca3dbcd32d0aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6354c39be5cdfa26ee563fecb997f57a722481421308951d783ca3dbcd32d0aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6354c39be5cdfa26ee563fecb997f57a722481421308951d783ca3dbcd32d0aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8124fb24b989cf8ac8f792c32efee16658c47eeff209ef7307346001f5d98b7"
    sha256 cellar: :any_skip_relocation, ventura:        "d8124fb24b989cf8ac8f792c32efee16658c47eeff209ef7307346001f5d98b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d8124fb24b989cf8ac8f792c32efee16658c47eeff209ef7307346001f5d98b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2886b391302aafb6744b2c8e30ce348af9120d898d649c75d2a757cfa312baf5"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7951fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https:files.pythonhosted.orgpackages1ec24ce1b1424e2d03b61fd153cf71933e5260f6b738bd4f2e0537708a91a23eb2sdk-2.1.0.tar.gz"
    sha256 "39116cc539ffa09c45eb9802b96416efafd255698d514303bdf3b7f7cf105f3f"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages21ffc495b797462434f0befcb598b51cde31c3ebdf8577c3fd9d9a8f5eeb844cdocutils-0.21.1.tar.gz"
    sha256 "65249d8a5345bc95e0f40f280ba63c98eb24de35c6c8f5b662e3e8948adea83f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "logfury" do
    url "https:files.pythonhosted.orgpackages90f224389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https:files.pythonhosted.orgpackages79cedb26f7f8ed4f4b200f34b8401ecaa9cbb0709f3c3822ae0d29a6019ad2a8phx-class-registry-4.1.0.tar.gz"
    sha256 "6a7fe8568f9000ad1f90c9a81c5cb65ec20ee3b89b2aaab7a67e14dbb67e11d1"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rst2ansi" do
    url "https:files.pythonhosted.orgpackages3c19b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages61c5c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources

    system bin"b2", "install-autocomplete", "--shell", "bash"
    bash_completion.install "#{Dir.home}.bash_completion.db2"
  end

  test do
    assert_match "-F _python_argcomplete b2",
                 shell_output("bash -c \"source #{bash_completion}b2 && complete -p b2\"")
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end