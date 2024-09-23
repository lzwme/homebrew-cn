class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https:github.comawslabsaws-shell"
  url "https:files.pythonhosted.orgpackages0131ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8dfb3f2f33bc76a42f69cf48073022a46f18a86b9b1b4d01ab6267082ddb08d2"
    sha256 cellar: :any,                 arm64_sonoma:  "07940c0bd98f48fc907d3e87bec2a351ceaf734673fec40189e03b294afd52e5"
    sha256 cellar: :any,                 arm64_ventura: "53d6d6c7e43011c0537c80635fc7ec851f138c11aef410682d113c1a756052d3"
    sha256 cellar: :any,                 sonoma:        "0c0a34412507865d786cfa023dc58bbcd9a6fd33b21169ab4218389f197be6cb"
    sha256 cellar: :any,                 ventura:       "7a1e21b7ebccd7d035ea19ef74d018dfb2a10ebce04392d86366370eb03941e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4608b15c178f72a69cdc86b8f8795925521deaf657d08edbeb9c807de12b095"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "awscli" do
    url "https:files.pythonhosted.orgpackages215a5f9ff673a205130ade8125a165f56be99458bb934341822297682f18be8dawscli-1.34.24.tar.gz"
    sha256 "466a41e85f15957af2d5e9d601c8c4808bea44547ac3a7e082186df0f932534e"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackagesc2e4b3438c3493a5b534f86308809029dc72c854b6007c331c03893345799a35boto3-1.35.24.tar.gz"
    sha256 "be7807f30f26d6c0057e45cfd09dad5968e664488bf4f9138d0bb7a0f6d8ed40"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages44688c6e4e8d7ec73f4daa0a1411dd0b3efcb06ed77c8d02ae95c90b85afdcbcbotocore-1.35.24.tar.gz"
    sha256 "1e59b0f14f4890c4f70bd6a58a634b9464bed1c4c6171f87c8795d974ade614b"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages2fe03d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219ddocutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesc564c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4cprompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesdbb5475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"aws-shell", "--help"
  end
end