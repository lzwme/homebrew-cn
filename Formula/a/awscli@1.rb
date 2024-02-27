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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36670680a373b0e21d277ba513505963c6e007e1f862546bdf0dfe36dfddf118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5f7cc86a8c564dc2df82d4313fcfbdf193074d69a0e221fe800de4e65b6d984"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ce18e34ee7d329ed00ec37f6129a2d001c7cd857bf6f39f8b7c46215d18905"
    sha256 cellar: :any_skip_relocation, sonoma:         "a50e0c863a7151a921134f90bd7e0fb79009cd2649033c41444bca8fa6912cdb"
    sha256 cellar: :any_skip_relocation, ventura:        "eb84f3ec76598de80e8d62681c0e099d1497540df8c2a173bf6fa3e2bad11b50"
    sha256 cellar: :any_skip_relocation, monterey:       "636db211b2eac7f01a9f2c4996811490cad98f2d0252954ed3e77f9e611f6848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e78e7fa848624fc60208506b6ed466678ed3d6f8a03228ffab7ecb59ba9ad08c"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages48afd038bd03233fe5c009fd67e8e1bfa6536c3b2ab91737cc629acbff464aa3botocore-1.34.50.tar.gz"
    sha256 "33ab82cb96c4bb684f0dbafb071808e4817d83debc88b223e7d988256370c6d7"
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