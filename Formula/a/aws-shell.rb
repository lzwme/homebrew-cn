class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaf27ed12585ec444d44da6bf199e69bf5612d0c77a4b26f5b23503d0eae11aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a114891ad7ff51fc9a97c7e4e43a77d9d47ec33a9bac3faafcc47b9e81bbbc18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79518c0775923795eead774c4b08558d92cc9b9cb2e7e6710808fa00fd7081ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "753eb66a18ae95842b8552cd052549aeaf8e4992e22dbd52f897ff00f8eacbd3"
    sha256 cellar: :any_skip_relocation, ventura:        "f9ad906cfb80bf60b5d22d3a9e8d9d6c9db199160f153fd90342dd97943ee840"
    sha256 cellar: :any_skip_relocation, monterey:       "3b08df3d518156f8e4d8c33653669bc4d08bdd73afb9b9d9fa5ddb4b1326442a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b95e051b3132c04035efc5e96f6340d3edf43e19d8d6da838f76bb97b1574ccd"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/f8/a6/d027f84540bff9fcb6c4f716564d70e48d1c57b599e22c89e05d3e429032/awscli-1.29.68.tar.gz"
    sha256 "71256d90a13be2bf0ff3385bbffd10adca3f9fdabfb60a249acb223d55691572"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/73/a5/76c27e79a1949a124b48e184bc3fa5b7b8577e1753f0e49ef9675278b0a8/boto3-1.28.68.tar.gz"
    sha256 "cbc76ed54278be8cdc44ce6ee1980296f764fdff72c6bbe668169c07d4ca08f0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/10/98/b46de13cc3dd64e1b9690ff5f60c4497d404d6ad7f6b9c6b2ba849d5b4b5/botocore-1.31.68.tar.gz"
    sha256 "0813f02d00e46051364d9b5d5e697a90e988b336b87e949888c1444a59b8ba59"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/64/c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4c/prompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    # setuptools>=60 prefers its own bundled distutils, which is incompatible with docutils~=0.15
    # Force the previous behavior of using distutils from the stdlib
    # Remove when fixed upstream: https://github.com/aws/aws-cli/pull/6011
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      virtualenv_install_with_resources
    end
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end