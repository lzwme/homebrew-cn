class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  url "https:github.comawsaws-cliarchiverefstags2.27.16.tar.gz"
  sha256 "87c56fae8879f91fdb25ee77357ce03165408958338e761d00f6906145883c22"
  license "Apache-2.0"
  head "https:github.comawsaws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79b3c86470bb6246a8cc24fb0bb6ef0b81f7f3ccc047cb33c090a019515c57e9"
    sha256 cellar: :any,                 arm64_sonoma:  "ae714dfca3ffbf9fb5d982577d26ec16eda93338ff74083379576737f27be749"
    sha256 cellar: :any,                 arm64_ventura: "a45d3f63e50e031d3ef79d9a222b4dafcaaf54caa289db9c7fcf3517b4a24092"
    sha256 cellar: :any,                 sonoma:        "bd99199390c76caff4e60c53bb0e8a5d7beee4781d05fc769a0f9976d550155e"
    sha256 cellar: :any,                 ventura:       "d1d75ef1f5f5bee2a4cdea04cd93e1c0dc55a4e0bbe04f02e2ea25d81749d279"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b70080809c5e43ad68d5636e5654d1e4e178f3a517f593cdcbd0aa723cde97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b58e7593cc6043c959727a60744c5ff5842d5a151ee56158b170204bbf6368"
  end

  depends_on "cmake" => :build
  depends_on "cryptography"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "libffi"
  uses_from_macos "mandoc"

  resource "awscrt" do
    url "https:files.pythonhosted.orgpackages42db72989a426cdf2b9f38454b1cdba246b2d2e95a77397ad3df18d1d9d4f5b3awscrt-0.26.1.tar.gz"
    sha256 "a8d63a7dcc6484c5c1675b31a8d1b6726c3dc85b13796fb143dfb0072260935e"
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
    url "https:files.pythonhosted.orgpackages6959b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741bflit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
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
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
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

  def python3
    which("python3.13")
  end

  def install
    ENV["AWS_CRT_BUILD_USE_SYSTEM_LIBCRYPTO"] = "1"

    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| r.name == "awscrt" }
    # CPU detection is available in AWS C libraries
    ENV.runtime_cpu_detection
    venv.pip_install resource("awscrt")
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