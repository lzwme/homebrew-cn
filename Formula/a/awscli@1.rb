class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackages0cb8ebbf5f53e3794d480ca85fd05dd4ea0833b6afaa2442b59814778e1baa2bawscli-1.32.10.tar.gz"
  sha256 "491acb839012ca6a1bfa4123baca2ee46d4114e2463b1fca9cf049c37e554a17"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098b4c6a4d7258117b6c01376c0dced68d6ec97734829fd177c787290445d9c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e43e9e5302d9f971065a374ce4a89cd918f716078e177d6d6dddc29c3c2b16e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7e4658e93e11b499bfc5fe6c1566798f8ecd5dcdcd537e8f89753525e941c32"
    sha256 cellar: :any_skip_relocation, sonoma:         "31487851201fb8093e7e2e40f87407d145688bc5e8133b54489615f2acdc901a"
    sha256 cellar: :any_skip_relocation, ventura:        "7fda853dabc26d2dde3a72b5622c2fd7049b78f5a11dd674514ae6976d38382c"
    sha256 cellar: :any_skip_relocation, monterey:       "4a0572152a235cb3136b8f7945ae47119bf5c3cdfa0092d2ccb6329fd6158f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2829a4b273dd94b77f4f3e43ddb1743d91a3fc3a8603c28d51db13567664bea"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages4e2dcbc27ff5260d0025a72625dada7560b9df0c89efefd8100ca012264e0b25botocore-1.34.10.tar.gz"
    sha256 "e981d2d727f26732753269d60a51a1851ad9de6c1aa823e5443c7b06221aada0"
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