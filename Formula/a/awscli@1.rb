class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/87/25/fb374f181606f4a79a0a9e307a76b7cbeb9824eff0363492f15dead77776/awscli-1.31.10.tar.gz"
  sha256 "26b16d18d7c7fe6a54b7c173b838fa454e4090f98668664028ea3297b12e2c99"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b916318e5e2d41464998bdd6c1a8f938567cb72a69391b739bc5f4af532467d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "468edc42a171c54d0ebf2ef6c399f9c5af1cc64ff0f8a914ae5419f5c775449f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc305c6a653fbbd8317ecbd419750653daa28a96fbd9a100b2b47b0584e5850c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea21a18cc85c03eeb90fbd1ef96eca89729274865eff072ffadf54e9f8f968d7"
    sha256 cellar: :any_skip_relocation, ventura:        "f774d0ea368b10666adce56b5624c940b563ea8557bbbdd37fe34e2842fb4821"
    sha256 cellar: :any_skip_relocation, monterey:       "ac9ced79144a46c6a6e138aac16cb1cb7dddbea7b59772ebf11be57af5826fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488b682feaa776c10df213bbbb7724653b33fe2cad5c5e9d112847c1a1eeae3d"
  end

  keg_only :versioned_formula

  depends_on "docutils"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/23/66/111f025eaa4f77b974f0d738a9ca94fb97f9a54dddb773b65acf7c3bee0b/botocore-1.33.10.tar.gz"
    sha256 "82be3da9ceac9d847d115a80f0a0dae020c3534ef88839ef907eb3205309fd4a"
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
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
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
    url "https://files.pythonhosted.org/packages/5f/cc/7e3b8305e22d7dcb383d4e1a30126cfac3d54aea2bbd2dfd147e2eff4988/s3transfer-0.8.2.tar.gz"
    sha256 "368ac6876a9e9ed91f6bc86581e319be08188dc60d50e0d56308ed5765446283"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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