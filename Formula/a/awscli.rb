class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  url "https:github.comawsaws-cliarchiverefstags2.25.6.tar.gz"
  sha256 "68b20ef4cd2542e4899cbc576dd854b7aed3561869b14b0af75a7ed078b61227"
  license "Apache-2.0"
  head "https:github.comawsaws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4153ad7628fc6aaa853e3e514133a4d4c4d269debd1f3a9223254591b38d356"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6589900211ddc82931e0dd3c1d572a47922dc05db4e8a2133c8c6a2fcd9f838"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb6de53c9976286ad6e6d45b97fc8ae82ff82b2e93a0b44da7cb74da8e629f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3eb61e41ffbddb89a356392d186db8e05b9907e489f83c4767b1948a24d4b94"
    sha256 cellar: :any_skip_relocation, ventura:       "6ef20d4e8848ad1ce493c84533ac2969e43818ed0d312a18b7cb3b47394f20bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d314f0da70dddfba8c0da59ca32a753adab4d34f878526d9cd7e17f3222a456"
  end

  depends_on "cmake" => :build
  depends_on "cryptography"
  depends_on "python@3.12" # Python 3.13 issue: https:github.comawsaws-cliissues9234

  uses_from_macos "libffi"
  uses_from_macos "mandoc"

  on_linux do
    depends_on "openssl@3"
  end

  resource "awscrt" do
    url "https:files.pythonhosted.orgpackagesfe500e3fd91488e5f0a18bc829869fc081cf4d9cd86642d9ee21b32907b02e80awscrt-0.23.8.tar.gz"
    sha256 "cba55f3ee80ea3192a0a24e84caad778570250800a59d29ef9efbcd4d1612f2f"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackages4b89eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages6b5c330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91fdocutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "flit-core" do
    url "https:files.pythonhosted.orgpackagesd5ae09427bea9227a33ec834ed5461432752fd5d02b14f93dd68406c91684622flit_core-3.10.1.tar.gz"
    sha256 "66e5b87874a0d6e39691f0e22f09306736b633548670ad3c09ec9db03c5662f7"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages4bbb75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415aprompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackagesd977bd458a2e387e98f71de86dcc2ca2cab64489736004c80bc12b70da8b5488python-dateutil-2.9.0.tar.gz"
    sha256 "78e73e19c63f5b20ffa567001531680d939dc042bf7850431877645523c66709"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages46a96ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3cruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese4e86ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392furllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages54bf5c0000c44ebc80123ecbdddba1f5dcd94a5ada602a9c225d84b5aaa55e86zipp-3.20.2.tar.gz"
    sha256 "bc9eb26f4506fda01b81bcde0ca78103b6e62f991b381fec825435c836edbc29"
  end

  def python3
    which("python3.12")
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"

    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources
    venv.pip_install_and_link buildpath, build_isolation: false

    pkgshare.install "awscliexamples"

    rm bin.glob("{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}")
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
    site_packages = libexecLanguage::Python.site_packages(python3)
    assert_includes site_packages.glob("awsclidata*"), site_packages"awsclidataac.index"
  end
end