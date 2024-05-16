class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https:github.comBackblazeB2_Command_Line_Tool"
  url "https:files.pythonhosted.orgpackages21ba18732056e0ff5c7e121ffc0cb758f14cbd4da939057e6015920eec304bc4b2-4.0.1.tar.gz"
  sha256 "aa4f0cc3705159b64829041d37f63f8a38d4a9513beae84bc740db0569dd84b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1c0f3b4d8d14337abd2d302cf13b4405e1c742d5a6953645f60d8e66c6484ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "736b77821fb23e365c70397c294fed4a66a09b7f86f23b9176ce013ca014cf60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d66322bf25a1b8b4b07707ae61b528ca6edf95955939010254944cab777572cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac4c4cfb3f40d3ebe800c3d2316757157eae746ae7c11798aa5dfd8f4723477d"
    sha256 cellar: :any_skip_relocation, ventura:        "71260e604d1c5e4cf878d87b71d8458b6d98158b8c56f6ec442311c0f4d8c579"
    sha256 cellar: :any_skip_relocation, monterey:       "0052ec8e0c6a22b0ac37bef362dd5051c9e78486e781aad287c9634c3669e462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0276a9257b01fe71180f5fcf73877145b66cc8e1749963397de2e6effc874aab"
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
    url "https:files.pythonhosted.orgpackagesc548c4ea740b86dae595ab0f3a03de24ff5918bc9c9dc0ea8ca7dede2097af5db2sdk-2.3.0.tar.gz"
    sha256 "fc292fceb5ec35c0dfd681f23e76b4449b63bb82d00423fc54edc0f4363f53e1"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
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
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
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
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
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