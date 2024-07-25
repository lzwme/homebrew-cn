class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackages8608a0262f8f762ae99017539d7566c4d0151a00b7b53d30b592e35aaeada871awscli-1.33.30.tar.gz"
  sha256 "a312b5a06b9cbad4b975bd86dd8fec15326594727f2da2025effc11638dafc89"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32ad53c2007fbac47c432589ddbbc8cd5df48ed4ba489c70cd1800d9688053c8"
    sha256 cellar: :any,                 arm64_ventura:  "076af62453a68d259be682c053d53f3740c6f96b6ee52a1bcaa325c5e4f20fa8"
    sha256 cellar: :any,                 arm64_monterey: "61b956f55e6bdc83af5d0d9c198d0033fabdff17f57ebc4b8cc30d054106f041"
    sha256 cellar: :any,                 sonoma:         "41417c4da1fa0865741ab57fab42193bcb072d870c2cfb2a8a593bc79df151da"
    sha256 cellar: :any,                 ventura:        "3ec507d0f4942c0c17a51681d7ee6b19315a51edb2b52356fdac68915717b497"
    sha256 cellar: :any,                 monterey:       "867a054197d4f910488f5dcb52f058bd76236acfa445eb4b64673b50d45e861a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406ac58e66ef5bb13831a1c8e13cf71c3c2120e84fc977713de78e7bb35bfd36"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages0feb04484db3afbe594c0c15e07dd4e4ba382d24b3170752282031f14b395d99botocore-1.34.148.tar.gz"
    sha256 "258dd95570b43db9fa21cce5426eabaea5867e3a61224157650448b5019d1bbd"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages2fe03d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219ddocutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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
    url "https:files.pythonhosted.orgpackagescb6794c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fabs3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscliexamples"

    rm Dir["#{bin}{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "binaws_bash_completer"
    zsh_completion.install "binaws_zsh_completer.sh"
    (zsh_completion"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}shareawscliexamples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}aws help")
  end
end