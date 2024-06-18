class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https:github.comBackblazeB2_Command_Line_Tool"
  url "https:files.pythonhosted.orgpackages87e0259cb2b16949ce534b4d9f7b7c34488978e30da3408a9038bfc993dcb4e3b2-4.0.2.tar.gz"
  sha256 "d9002443d66deac92a476eb88c6c00c93da9fb87dcefad6dc9bf06b5efb06b27"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6cde728041e1a2af8f83cd0b145238aae1183c58c644f983afe08a9641d5b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6cde728041e1a2af8f83cd0b145238aae1183c58c644f983afe08a9641d5b88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6cde728041e1a2af8f83cd0b145238aae1183c58c644f983afe08a9641d5b88"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f461d9e28dd2a29c3d83c4467dc048ac1ca06a9b01abfd686c182d443353cc"
    sha256 cellar: :any_skip_relocation, ventura:        "a4f461d9e28dd2a29c3d83c4467dc048ac1ca06a9b01abfd686c182d443353cc"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f461d9e28dd2a29c3d83c4467dc048ac1ca06a9b01abfd686c182d443353cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2b69e60f94c994153d7294edc2f9aefaab809aec71adf1a4cab672540a468e"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesdbca45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91fargcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https:files.pythonhosted.orgpackages3349c6370ad84445b4a85ea88475511160ee00e368511bcf2dc9c9eedf11d3e8b2sdk-2.4.0.tar.gz"
    sha256 "95122d163819c233e8b11b4a1d87fcd3b9c4eb62db78b69bd231e20aa91547fb"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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