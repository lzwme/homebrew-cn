class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https:github.comBackblazeB2_Command_Line_Tool"
  url "https:files.pythonhosted.orgpackages1db70af30c4a6c0344e897a153f4f0022b041bf803562d047d6f0140940c2e8eb2-4.3.3.tar.gz"
  sha256 "a66f78e91f8ac36721093b751d09d3d228957473ee3df50b5138e72290e32646"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8d9668cb85b020e41ebda2854aec79b644896488f061b336789108bf728be05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8d9668cb85b020e41ebda2854aec79b644896488f061b336789108bf728be05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8d9668cb85b020e41ebda2854aec79b644896488f061b336789108bf728be05"
    sha256 cellar: :any_skip_relocation, sonoma:        "31e83a7a76d20d3994bcec5bb1be4e95e6c1cf7a38a9f706eac49f0ec5326c2b"
    sha256 cellar: :any_skip_relocation, ventura:       "31e83a7a76d20d3994bcec5bb1be4e95e6c1cf7a38a9f706eac49f0ec5326c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e669cda345803fd027a6be564b6e1137b5754e3c5dc3e445e4eaca4fb109c65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e669cda345803fd027a6be564b6e1137b5754e3c5dc3e445e4eaca4fb109c65b"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "b2sdk" do
    url "https:files.pythonhosted.orgpackages79b3ae7eb61b56eaf3fc96b222bd571273842b641279998052eb63877c52ce16b2sdk-2.9.3.tar.gz"
    sha256 "d8f94b3ca2f91852439673d27d6436b353dba1fc8db6b960f3d26c17539574ae"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackagesaeedaefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rst2ansi" do
    url "https:files.pythonhosted.orgpackages3c19b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesef88d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
    output = shell_output("#{bin}b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1", 1)
    assert_match "unable to authorize account", output
  end
end