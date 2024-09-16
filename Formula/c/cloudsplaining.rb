class Cloudsplaining < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM Security Assessment tool"
  homepage "https:cloudsplaining.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackages27c3a41d0974e00291798d3a5a18c7c0c7fd2880d8fbf69ebe115e89325bde85cloudsplaining-0.7.0.tar.gz"
  sha256 "2d8a1d1a3261368a39359bb23aa7d6ac9add274728ff24877b710cdfa96d96af"
  license "BSD-3-Clause"
  head "https:github.comsalesforcecloudsplaining.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7c52be8c64703a1f5d42d86c19a91fd8938849bc59e1edaa628e20d9c97f5be3"
    sha256 cellar: :any,                 arm64_sonoma:  "fc712783e39ae5f45379f2bbdfc4543502bea22a980f25d67fec7d2be91b9103"
    sha256 cellar: :any,                 arm64_ventura: "f48c595869087d9abab3b184f6a5b72c5c543e71b1a49d6c6bc6146bec759d56"
    sha256 cellar: :any,                 sonoma:        "597fa4494945ef0bccb050f0673755ac5c529ef01900227a2f843e6cc5aaa7f4"
    sha256 cellar: :any,                 ventura:       "0ee5f36cdd7ad1ed59d873f0fcc019bba966c69cf9268c54b8d4d1b2047b1971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71ba33cea0f36a1073b676af739d97f4e7d37bb9ce8b021ec9281c59b30c0aef"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages8085d4119201c65b56a2bcc8dc328db98cd1c769a2376aea1613a6f5e8f2a88bboto3-1.35.19.tar.gz"
    sha256 "9979fe674780a0b7100eae9156d74ee374cd1638a9f61c77277e3ce712f3e496"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages68e4d0114af2ec0495c7b415b5a739a3f5b7c35a4e0b7ecfd1a7ea533606f834botocore-1.35.19.tar.gz"
    sha256 "42d6d8db7250cbd7899f786f9861e02cab17dc238f64d6acb976098ed9809625"
  end

  resource "cached-property" do
    url "https:files.pythonhosted.orgpackages612cd21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
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
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
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
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages9e03821c8197d0515e46ea19439f5c5d5fd9a9889f76800613cfac947b5d7845orjson-3.10.7.tar.gz"
    sha256 "75ef0640403f945f3a1f9f6400686560dbfb0fb5b16589ad62cd477043c4eee3"
  end

  resource "policy-sentry" do
    url "https:files.pythonhosted.orgpackages524f02922c178ca4acbe21f5d1252209ccc05bb70d515ca406925ae7e34e164fpolicy_sentry-0.13.1.tar.gz"
    sha256 "6bb0133d897a45349aed78942459b4f583542051bb181e3a64464d13af8190b0"
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
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "schema" do
    url "https:files.pythonhosted.orgpackagesd4010ea2e66bad2f13271e93b729c653747614784d3ebde219679e41ccdceecdschema-0.7.7.tar.gz"
    sha256 "7da553abd2958a19dc2547c388cde53398b39196175a9be59ea1caf5ab0a1807"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cloudsplaining --version")

    output = shell_output("#{bin}cloudsplaining download 2>&1", 1)
    assert_match "botocore.exceptions.NoCredentialsError: Unable to locate credentials", output
  end
end