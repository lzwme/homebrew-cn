class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https:github.comawslabsaws-shell"
  url "https:files.pythonhosted.orgpackages0131ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25c783491817c522035224a860ca396153b767aedfd6aeb1c3293982f0402fbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "916a3c58a50542afce354b2973d7d0a2f6b433f7bcbefcbcfa60aca60aa6dbf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0845806e8dcb4728c80ae18b5389aea7055dd99472f49b28ceef718690af720f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bb6f76520d66420ab6c8b77c106bdb99e2bd30389e27b6269bbf7b4f5bec56e"
    sha256 cellar: :any_skip_relocation, ventura:        "e37cd094a982ee15d05c7e505e1a0e7527a2eae3502ae6d8f955e01f48c3f9f6"
    sha256 cellar: :any_skip_relocation, monterey:       "f6b6b005857e154b8209b778fce3d7f88f938c1845ae6a292259688cf3c28031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fd717c5e564bb254920636f995c34d203805e966cffaa4094d83571563bfb1"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.12"
  depends_on "six"

  resource "awscli" do
    url "https:files.pythonhosted.orgpackagesf8a6d027f84540bff9fcb6c4f716564d70e48d1c57b599e22c89e05d3e429032awscli-1.29.68.tar.gz"
    sha256 "71256d90a13be2bf0ff3385bbffd10adca3f9fdabfb60a249acb223d55691572"
  end

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages73a576c27e79a1949a124b48e184bc3fa5b7b8577e1753f0e49ef9675278b0a8boto3-1.28.68.tar.gz"
    sha256 "cbc76ed54278be8cdc44ce6ee1980296f764fdff72c6bbe668169c07d4ca08f0"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages1098b46de13cc3dd64e1b9690ff5f60c4497d404d6ad7f6b9c6b2ba849d5b4b5botocore-1.31.68.tar.gz"
    sha256 "0813f02d00e46051364d9b5d5e697a90e988b336b87e949888c1444a59b8ba59"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackages1fbb5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbecolorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
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
    url "https:files.pythonhosted.orgpackages61ef945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89dpyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesdbb5475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages3fff5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagescbee20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04bawcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}aws-shell", "--help"
  end
end