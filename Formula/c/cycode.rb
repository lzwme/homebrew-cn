class Cycode < Formula
  include Language::Python::Virtualenv

  desc "Boost security in your dev lifecycle via SAST, SCA, Secrets & IaC scanning"
  homepage "https:github.comcycodehqcycode-cli"
  url "https:files.pythonhosted.orgpackagese23e2b7ec66b8e0910d6721011b4b3abb1c70a6e799abff66f41f870dbbc2af0cycode-3.0.1.tar.gz"
  sha256 "0f5c2623385fda7c76e3627a2420fe91034df147d3409facf686f56bc394b045"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "111f7a621dc787befd675db9b5d77f1b1d3925624abce953e2b6196a686630f1"
    sha256 cellar: :any,                 arm64_sonoma:  "2142a468c24ace2aa9dadc0551625eeab2d6097d5a259d589bd211c4f03edb51"
    sha256 cellar: :any,                 arm64_ventura: "f00d62bf7f6381c2ecf95b581019b9c278e90822bd1055eee65f12bee9206fd7"
    sha256 cellar: :any,                 sonoma:        "153349a612aa598f815f2b83999e63532a620e19811250d702613621f52ea5ac"
    sha256 cellar: :any,                 ventura:       "f051fbb7f1e85df2e7b0658fe860b4ead1dace488fa057344b0a96c46ab4ece4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6366e898b5affd89d71f14431ba6fd5f1e467f4150c17e7df62b7b4cfe46407a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdb881cd6d816d989ac7e86054f6c0c807f907b34af6991b4faebee34b431a3d"
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
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
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

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackages7040faa10dc4500bca85f41ca9d8cefab282dd23d0fcc7a9b5fab40691e72e76marshmallow-3.22.0.tar.gz"
    sha256 "4972f529104a220bb8637d595aa4c9762afbe7f7a77d82dc58c1615d70c5823e"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "patch-ng" do
    url "https:files.pythonhosted.orgpackageseec053a2f017ac5b5397a7064c2654b73c3334ac8461315707cbede6c12199ebpatch-ng-1.18.1.tar.gz"
    sha256 "52fd46ee46f6c8667692682c1fd7134edc65a2d2d084ebec1d295a6087fc0291"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "sentry-sdk" do
    url "https:files.pythonhosted.orgpackages5ebb6a41b2e0e9121bed4d2ec68d50568ab95c49f4744156a9bbb789c866c66dsentry_sdk-2.28.0.tar.gz"
    sha256 "14d2b73bc93afaf2a9412490329099e6217761cbab13b6ee8bc0e82927e1504e"
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

  resource "tenacity" do
    url "https:files.pythonhosted.orgpackagescd9491fccdb4b8110642462e653d5dcb27e7b674742ad68efd146367da7bdb10tenacity-9.0.0.tar.gz"
    sha256 "807f37ca97d62aa361264d497b0e31e92b8027044942bfa756160d908320d73b"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackages6c89c527e6c848739be8ceb5c44eb8208c52ea3515c6cf6406aa61932887bf58typer-0.15.4.tar.gz"
    sha256 "89507b104f9b6a0730354f27c39fae5b63ccd0c95b1ce1f1a6ba0cfd329997c3"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesef88d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  def install
    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # defer installation to allow `typer` to use argument as shell for completions
    # Ref: https:typer.tiangolo.comfeatures#user-friendly-cli-apps
    venv = virtualenv_install_with_resources without: "shellingham"
    generate_completions_from_executable(bin"cycode", "--show-completion")
    venv.pip_install resource("shellingham")
  end

  test do
    status = shell_output("#{bin}cycode status")
    assert_match version.to_s, status
    assert_match "Is authenticated: False", status
    assert_match "Ignore by type is missing", shell_output("#{bin}cycode ignore 2>&1", 1)
    assert_match "Cycode client id needed.", shell_output("#{bin}cycode scan path 2>&1", 1)
    output = shell_output("#{bin}cycode scan -t test 2>&1", 2)
    assert_match "Invalid value for '--scan-type'  '-t'", output
  end
end