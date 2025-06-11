class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https:cruft.github.iocruft"
  url "https:files.pythonhosted.orgpackagesd17e0e20012f2aa156e5d6a70483a8d90accb7ed4966dddb0c58987d9f6eba12cruft-2.16.0.tar.gz"
  sha256 "184662853fbc1c16c0137fe0e9444e0cbe95e40362f5ebb2d9fae33d9223e73f"
  license "MIT"
  revision 2
  head "https:github.comcruftcruft.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad39579e5cf67e9d038dcbb90428a2c3e2d570d70c6245138cb1876ba5136ea0"
    sha256 cellar: :any,                 arm64_sonoma:  "190c707c426a09da51c614293b3ce5045864b492227e7cfcc82d48271e7314ea"
    sha256 cellar: :any,                 arm64_ventura: "b3b1e6260b9008152344573405a8a5330371c3e164d52735ee3c6d3762e7a584"
    sha256 cellar: :any,                 sonoma:        "0fcdf19675bf13a33bbed2a19ab926173ddfad61cb070002f34478b58f92767e"
    sha256 cellar: :any,                 ventura:       "1dd9db1dec2951bb2182ed9d179a17152bba07870d6fcb8bda4f32e6345f77dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4f67fafa0a04fd79a855ceb3cdb127c09f9cc8d28cda246461eaea7e714692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2703585445ce3628a1a6b51bcbf85ccd381cc24f2ca822384976803e8f6e4816"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "binaryornot" do
    url "https:files.pythonhosted.orgpackagesa7fe7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49bbinaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "cookiecutter" do
    url "https:files.pythonhosted.orgpackages52179f2cd228eb949a91915acd38d3eecdc9d8893dde353b603f0db7e9f6be55cookiecutter-2.6.0.tar.gz"
    sha256 "db21f8169ea4f4fdc2408d48ca44859349de2647fbe494a9d6c3edfc0542c21c"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https:files.pythonhosted.orgpackages87c75e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4apython-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "text-unidecode" do
    url "https:files.pythonhosted.orgpackagesabe2e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagesc58c7d682431efca5fd290017663ea4588bf6f2c6aad085c7f108c5dbc316e70typer-0.16.0.tar.gz"
    sha256 "af377ffaee1dbe37ae9440cb4e8f11686ea5ce4e9bae01b84ae7c63b87f1dd3b"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesef88d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"cruft", "create", "--no-input", "https:github.comaudreyrcookiecutter-pypackage.git"
    assert (testpath"python_boilerplate").directory?
    assert_path_exists testpath"python_boilerplate.cruft.json"
  end
end