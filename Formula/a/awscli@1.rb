class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https:files.pythonhosted.orgpackagesed5b2fafc8534ba802f7d9dd4f133b83f2495c6835788dbe8ca65ece2d1de6b6awscli-1.37.20.tar.gz"
  sha256 "2439d41457ce9f5dd4e4758569a3be2f5e503a0d5f4612afc98f5972dc0673f2"
  license "Apache-2.0"

  livecheck do
    url "https:github.comawsaws-cli.git"
    regex(^v?(1(?:\.\d+)+)$i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b245507806d574ae978700aaa430898e72ef8ca76a1f5f4b0c3e85266cdeec9"
    sha256 cellar: :any,                 arm64_sonoma:  "d203ce2da773c2cc4098732ec9a992515c69d1a8a63e0394fd498719dd8fcc50"
    sha256 cellar: :any,                 arm64_ventura: "8ca19441264d2b334cf452a771ad0a5a73291111e202351f7a98ce74c358b34b"
    sha256 cellar: :any,                 sonoma:        "733b2eb70391cb393277b42c882f3cb79632663d7181074adda6938087d6ae56"
    sha256 cellar: :any,                 ventura:       "ddc6e632084334e0689dce99e9391a4b0fbbc36ae338b6c8bf76871a5833265b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe2477b910913db348f3091a266dc0e6d41d4501537e997f486dc3a207c446a"
  end

  keg_only :versioned_formula

  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "mandoc"

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages1dd52d54195cefa89708186c036db360d9be23aabdb93d8982df9c08e6df1ef8botocore-1.36.20.tar.gz"
    sha256 "3815a05518ff03a8dbc8d5a3c29b95889409a25ac87a282067f6e26fefb7c40a"
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
    url "https:files.pythonhosted.orgpackages62452323b5928f86fd29f9afdcef4659f68fa73eaa5356912b774227f5cf46b5s3transfer-0.11.2.tar.gz"
    sha256 "3b39185cb72f5acc77db1a58b6e25b977f28d20496b6e58d6813d75f464d632f"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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