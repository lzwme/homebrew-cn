class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https:cloudsplaining.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages6e09acb8e088d1c6cc6fc9d6d42c1e61168f36339f13b1ea8e54f9a7e93949d1cloudsplaining-0.8.0.tar.gz"
  sha256 "02029432316a56551e58296496bc80e4778a58468273dbcd61df4ed2c369ede4"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comsalesforcecloudsplaining.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee37ddda13b58065f7bef47caf31091e91cbceddc7f5a9142e1e69dd88a1bcbd"
    sha256 cellar: :any,                 arm64_sonoma:  "f364f470b80e1fff1cff3c3815ddc44d4f6d59862fd8e57ce3d879078ceaced2"
    sha256 cellar: :any,                 arm64_ventura: "8336328a62cab5384ec8c55e626638ad50c2e6494537fed1bf5094c33a243d31"
    sha256 cellar: :any,                 sonoma:        "c79e09ac0fdd27e79f449809d89557a84cee5b43d4dbf11a3b3f4a875d4e33d9"
    sha256 cellar: :any,                 ventura:       "d1196fed9771284659d539ca34d894926445223d5c4af15807f2cc4039dfbf52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "077b6ccde8c6c40c313a000700049c28a6a7b997d4d3e430c13d928d9769e57e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bbba75f816193064411549d5770401aa5c180b1c298223920487df432436459"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesad9599046c55799732d97b0f9a0bb99b64760f07dd55ac793393a6c4e847d8d6boto3-1.38.33.tar.gz"
    sha256 "6467909c1ae01ff67981f021bb2568592211765ec8a9a1d2c4529191e46c3541"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9daa1521d7e1dcb76af8dca81539eec141ee3581a32e0dc1f31d092b59feb06abotocore-1.38.33.tar.gz"
    sha256 "dbe8fea9d0426c644c89ef2018ead886ccbcc22901a02b377b4e65ce1cb69a2b"
  end

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages764b3d870836119dbe9a5e3c9a61af8cc1a8b69d75aea564572e385882d5aefbcached_property-2.0.1.tar.gz"
    sha256 "484d617105e3ee0e4f1f58725e72a8ef9e93deee462222dbd51cd91230897641"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagesb99f1f917934da4e07ae7715a982347e3c2179556d8a58d1108c5da3e8f09c76click_option_group-0.5.7.tar.gz"
    sha256 "8dc780be038712fc12c9fecb3db4fe49e0d0723f9c171d7cda85c20369be693c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "markdown" do
    url "https:files.pythonhosted.orgpackages2f15222b423b0b88689c266d9eac4e61396fe2cc53464459d6a37618ac863b24markdown-3.8.tar.gz"
    sha256 "7df81e63f0df5c4b24b7d156eb81e4690595239b7d70937d0409f1b0de319c6f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages810bfea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "policy-sentry" do
    url "https:files.pythonhosted.orgpackagesbc4be03bbe626379bfee06c944a01ef25ad14ce30bc9dd86988dfda1cf343347policy_sentry-0.14.0.tar.gz"
    sha256 "5c52cebebad26e2360393f34af523c1685541d67b0dfd721b0779dbe9e327f1a"
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
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesed5d9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191as3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
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
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
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

    generate_completions_from_executable(bin"cloudsplaining", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cloudsplaining --version")

    output = shell_output("#{bin}cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end