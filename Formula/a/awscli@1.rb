class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackages949a1a1c099bd34259d225b695d5b6abe3d1a5cabcc1c2076191b6364b7e4841awscli-1.32.50.tar.gz"
  sha256 "6c02348ae6d5180e26f8063b192687bfd6f44197773d45e7de65c913ea1fe21d"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "dfada1ae7db7990e11fc0add0044c9d63b0800c7b3bcf070d78c5cc37d1943f8"
    sha256 cellar: :any,                 arm64_ventura:  "3f3ded4c85d00ceeab7ff06ef2c4825b689a4c29aec3b74ebe0edd5a493a779a"
    sha256 cellar: :any,                 arm64_monterey: "b73a19c7d49dbe6b01c7339d1610007eef4575a678b87920aeb25224bdb45c78"
    sha256 cellar: :any,                 sonoma:         "68d48d57a2e8781452f9dbaf9427f9e3d16cafd3ea0b4d60ac6354b182d436a3"
    sha256 cellar: :any,                 ventura:        "92f777f18bea32ba095bbf20f9e3fa715d60fcded0bfa678d60884727a578318"
    sha256 cellar: :any,                 monterey:       "9819fef1eb1fc1ffb2fe9316dd13bda54b0d5ebd08c8f817a04794d9359ad027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d290a63fe9279770a6619dba1aa67e855cfcdc01183c7b445cb92d0f1d77e3"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.12"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages48afd038bd03233fe5c009fd67e8e1bfa6536c3b2ab91737cc629acbff464aa3botocore-1.34.50.tar.gz"
    sha256 "33ab82cb96c4bb684f0dbafb071808e4817d83debc88b223e7d988256370c6d7"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackages1fbb5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbecolorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
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
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
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
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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