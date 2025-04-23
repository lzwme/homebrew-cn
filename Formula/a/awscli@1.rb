class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackages02dc3d2fe6661bff79e43c9e53f5e303f46af8e5d4fc496e28c46f9c9b4a2f80awscli-1.39.0.tar.gz"
  sha256 "1df88f057d0aeacc2fdc265dd3c0c8d87b55e1b9283def610594e47c77696e65"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "221b6b6ecd2249e4575a18fea9e424665f90e794fff0e2d081f130bd722556da"
    sha256 cellar: :any,                 arm64_sonoma:  "ea3cb3ea31e03fe0478f17583d9955e94216455244d04cca1b8674fd0d9d0cbe"
    sha256 cellar: :any,                 arm64_ventura: "85710cdd197bbef024f1b60fcf289e4c170086b3eb46e800646e4614e11002c9"
    sha256 cellar: :any,                 sonoma:        "3f65779fe87128840f13dad2b37c7ce890ee7f34f34f273d58191a58ff0e298c"
    sha256 cellar: :any,                 ventura:       "eecd6ad79a39e885ee5f5e8f101b9812b88164005ade7dab0487d50a7754badf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebcebfb60b46627c70a769a762f3fb97349987f352f94c94ee4865b833c2751e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e866e6fb9a5efb1c322dca185b9f00868160b88f65abfd98019f822385b57621"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages87be2bacb06ef6809c665f315adf4e4d760f84a9664762685e12cebccc241d25botocore-1.38.0.tar.gz"
    sha256 "ac8997291bcfd28d329a779ceda429fbe9f8950ba051429a37ba93cbda025e94"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages6b5c330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91fdocutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesdbb5475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackagesfc9e73b14aed38ee1f62cd30ab93cd0072dec7fb01f3033d116875ae3e7b8b44s3transfer-0.12.0.tar.gz"
    sha256 "8ac58bc1989a3fdb7c7f3ee0918a66b160d038a147c7b5db1500930a607e9a1c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscliexamples"

    %w[aws.cmd aws_bash_completer aws_zsh_completer.sh].each { |f| rm(binf) }
    bash_completion.install "binaws_bash_completer"
    zsh_completion.install "binaws_zsh_completer.sh"
    (zsh_completion"_aws").write <<~ZSH
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    ZSH
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