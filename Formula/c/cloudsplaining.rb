class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https:cloudsplaining.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages27c3a41d0974e00291798d3a5a18c7c0c7fd2880d8fbf69ebe115e89325bde85cloudsplaining-0.7.0.tar.gz"
  sha256 "2d8a1d1a3261368a39359bb23aa7d6ac9add274728ff24877b710cdfa96d96af"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comsalesforcecloudsplaining.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7f7ac4cc32819c519f81d7963c7c06f60a1b9a76ac508c74cf40b558c7557b0f"
    sha256 cellar: :any,                 arm64_sonoma:  "2e4dfb39b5463db00c95d54211e82c9972e29e5416ba3e1df405b173a8cc3208"
    sha256 cellar: :any,                 arm64_ventura: "d8aab0136a1315522fbc3ef947f56e5fadb20f9fa5bd8953c7950dc9716b70d6"
    sha256 cellar: :any,                 sonoma:        "45aa727d3dfd85e791400229f234769e128a40194d86b756827077010a7eb43a"
    sha256 cellar: :any,                 ventura:       "fb9a440d437e2abeac55ca19f98a875b49367446a106cdbe4a2a943e6893d92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be437d8a03cc9bdf2a741bcd39285b684cc921f92275702b7e43dce08bec67cc"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages8008cf2a60bcb6d49764379d78e87f29310458257eb413bb7aa85ebe3d8cd0ccboto3-1.35.87.tar.gz"
    sha256 "341c58602889078a4a25dc4331b832b5b600a33acd73471d2532c6f01b16fbb4"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages988d2e49e7a99944cbeef4c1182f59af282fcb164feef35dfa420500c4e0ccb3botocore-1.35.87.tar.gz"
    sha256 "3062d073ce4170a994099270f469864169dc1a1b8b3d4a21c14ce0ae995e0f89"
  end

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages764b3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefbcached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagese7b891054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages54283af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackagese004bb9f72987e7f62fb591d6c880c0caaa16238e4e530cbc3bdc84a7372d75forjson-3.10.12.tar.gz"
    sha256 "0a78bbda3aea0f9f079057ee1ee8a1ecf790d4f1af88dd67493c6b8ee52506ff"
  end

  resource "policy-sentry" do
    url "https:files.pythonhosted.orgpackagesa40575e8953eb5fa564e45fc5afc61696d38ce779169309ca270224561926fa8policy_sentry-0.13.2.tar.gz"
    sha256 "db2b39f92989077f83fc4dd1d064e3ff20b69cfed82168ebdc060e7dce292e77"
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

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesc00a1cdbabf9edd0ea7747efdf6c9ab4e7061b085aa7f9bfc36bb1601563b069s3transfer-0.10.4.tar.gz"
    sha256 "29edc09801743c21eb5ecbc617a152df41d3c287f67b615f73e5f750583666a7"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackagesd4010ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecdschema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"cloudsplaining", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cloudsplaining --version")

    output = shell_output("#{bin}cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end