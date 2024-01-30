class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackages062e94304a218bd9abb891876ed27326535b70998201236f0d7c7053fbb0de38awscli-1.32.30.tar.gz"
  sha256 "3b058e0ea0bf6e37848ae5da6a2c45febe3c0bf497682d7575aba8c8249a90f0"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07b663d6386e97624f891b669b2ee0f3009a5815392d26beffc62d76d5fea4ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dd3c2b001e7fce446cd3a38767890e2fa1c4c9c2728debffed3514577514ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fddbc8d124043f142e2690eff61696d7e7324a9fd99b56ee17d0eca804c262a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "438f7e17a98dfbd72c9f75bc90a7f835f51f5d966315a2a64a872dc6b69f18f4"
    sha256 cellar: :any_skip_relocation, ventura:        "30e210601c7027ca42552dda3630054b39993dc015286e48d7c48c8115003b89"
    sha256 cellar: :any_skip_relocation, monterey:       "493ad2bb8846e45996573e61f3a26b87fe50fb89abc39cb48db90734f444b1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb56b72aebcbfbd54ebb4bf2c12fbaf3c33546934745ce8d834993a79bf485c"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages3c1954dcdafc924d14547568d1f7de78b509aa9204773bf566239acdcc882d2fbotocore-1.34.30.tar.gz"
    sha256 "e071a9766e7fc2221ca42ec01dfc54368a7518610787342ea622f6edc57f7891"
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