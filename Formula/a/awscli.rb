class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  url "https:github.comawsaws-cliarchiverefstags2.17.16.tar.gz"
  sha256 "cbbd188e8be9d8ef1c41b5c4767e713eda30755f8316629b796cda2f730c1623"
  license "Apache-2.0"
  head "https:github.comawsaws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3f08894b45451d5c273dde6b95485cf1bbbaac17e7b7de1bcc4aaeb92b9452b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7885156c97e3d3f84cd27759f6b372afb901744c26a93be2d3c557561a153e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ed30af0a7ef244a90986578eae36496dea998a09f9887d80747d10d2b076b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "720d6161b3f6c6c976adf15b8e5231aacc7f0f20137bc5ab3c43673a073fa0b0"
    sha256 cellar: :any_skip_relocation, ventura:        "a4befabf5d652a87135b3469e1e5e041543a531e3550a3c16047378e9d5b38f9"
    sha256 cellar: :any_skip_relocation, monterey:       "2034deca32225f2fd10cfed24f79c4f3084e006ea68961cdefeb5ac7a3f5d582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0db925d81d476e9f86b170fae975bad3799358b8b6a92f77aab51dac79ac574"
  end

  depends_on "cmake" => :build # for awscrt
  depends_on "cryptography"
  depends_on "python@3.11" # Python 3.12 issue: https:github.comawsaws-cliissues8342

  uses_from_macos "libffi"
  uses_from_macos "mandoc"

  resource "awscrt" do
    url "https:files.pythonhosted.orgpackagesc9959faca9e404fd3cd72fa8f75d4f33f16032f3598a841e83dc81c687b4b80aawscrt-0.20.11.tar.gz"
    sha256 "c3dbfb7f1909457952e645373e72b69f90c50c465ee6a46d9bbdc12acb79803c"
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
    url "https:files.pythonhosted.orgpackagesc4e6c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
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
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages46a96ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3cruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackagesd531a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0bruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesc89365e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1burllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  def python3
    which("python3.11")
  end

  def install
    # The `awscrt` package uses its own libcrypto.a on Linux. When building _awscrt.*.so,
    # Homebrew's default environment causes issues, which may be due to `openssl` flags.
    # This causes installation to fail while running `scriptsgen-ac-index` with error:
    # ImportError: _awscrt.cpython-39-x86_64-linux-gnu.so: undefined symbol: EVP_CIPHER_CTX_init
    # As workaround, add relative path to local libcrypto.a before openssl's so it gets picked.
    if OS.linux?
      python_version = Language::Python.major_minor_version(python3)
      ENV.prepend "CFLAGS", "-I.buildtemp.linux-x86_64-#{python_version}depsinstallinclude"
      ENV.prepend "LDFLAGS", "-L.buildtemp.linux-x86_64-#{python_version}depsinstalllib"
    end

    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install resources.reject { |r| r.name == "awscrt" }
    # The `awscrt` resource requires `setuptools` & `wheel`, so they must be installed first
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
    assert_includes Dir[site_packages"awsclidata*"], "#{site_packages}awsclidataac.index"
  end
end