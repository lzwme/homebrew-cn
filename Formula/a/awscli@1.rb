class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/bc/d4/184b185a625010b19fa3771398c34a1edf11bb5a79a85011d3d00e6a1422/awscli-1.29.50.tar.gz"
  sha256 "c9a6d631a27f93d9d6cee80e0d9a91d46a06dbc01f8ada5f44bf3656ab465256"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "711641cb94b3803a0b5645636049222a46e1eb666ce94c5e43338dd02aebb58d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c6a724b12dc88265c87e1260dfcb5cf7eed4c97d0b45a1e02d5322090459126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fd9442a6df0308a5f853be0e085238d21c650153f78cdcb7bff86c466d1d51b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c156566c7d8a51dc67804803ceacfed1f42c263886c533e388659563814195ad"
    sha256 cellar: :any_skip_relocation, ventura:        "ba5f5e0b235d37a3b0f3798393eafaa2c1eeb3a34bd2f56976f37c3c0750f07a"
    sha256 cellar: :any_skip_relocation, monterey:       "d99eff5a290f0778d45b09d4b4e7a86731cb7045b1114970a3bc2030d5ca5882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68f788e6659cea4b57b04d338f3d9b472f9c729ef9f804c671379441089ef1d2"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/67/98/1418d326f5e10c8b86ccc0cc5651d2d348fed137328cd0ce627031eeae79/botocore-1.31.50.tar.gz"
    sha256 "a1343f2e38ea86e11247d61bd37a9d5656c16186f4a21b482c713589a054c605"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end