class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackages49712f92975d2db9a9f3800adfd57728a7983c6d8f67895fae76e318b9818d45awscli-1.32.20.tar.gz"
  sha256 "59ee2e38f79b7340d587c6c8b8a269f5b4d1034824dc3eae1d7547e003484164"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "737aaf7c94f2c28552600ec463848690ce8c23a8064f2e56016924b5da3c6f6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d0c5b452cc0fd5c4f97be9a2e04ff27459a14ccbc9202540ad89e2a1e650ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da2e37974b0a9bd71d2c26b281b2e4ad77006a752d4bdbe7537ce882c8ecbe7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3acff6172fc0cc24277c8781790021368a0fc48960c4778db951146a7a84284"
    sha256 cellar: :any_skip_relocation, ventura:        "c08509d19e017f199d6f5dc4c7b3517c7800a4311fafa26add5b55569eec657d"
    sha256 cellar: :any_skip_relocation, monterey:       "74f4fe8338f0905bd121345a47a1135528a567d055fb7d66add8eb2c3b1edf58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f48b8acc54a743b00c2010fdae65f8f22e2666ddc5663b08b9a3c69b436a3b"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages92d97e97f329ff1b94aaa3756c15eccd26395712353657ffdb23d144940e3ef8botocore-1.34.20.tar.gz"
    sha256 "e944bc085222a13359933f4c0a1cce228bdd8aa90e1f2274e94bd55f561db307"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackages1fbb5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbecolorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
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

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesdbb5475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesa0b54c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40bas3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
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