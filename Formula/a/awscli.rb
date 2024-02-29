class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https:aws.amazon.comcli"
  url "https:github.comawsaws-cliarchiverefstags2.15.24.tar.gz"
  sha256 "7b526df8c0f4ae7cf5fc6285e3b8c27b4e4fc5df7269e99b6ed3e5ded8cfa14c"
  license "Apache-2.0"
  head "https:github.comawsaws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3051f910350245139f6b5d8d605720ed730d7f733c014c7cfe50c8ccd0919373"
    sha256 cellar: :any,                 arm64_ventura:  "4a82fd704e3f2c1d98297bde89c8478d51c3853f18af92e1edf34e0ed1a5aae4"
    sha256 cellar: :any,                 arm64_monterey: "4163950baf6a5bb6083f987a598fd8577cadaf035e31e53f2bd6b5b41340d3b5"
    sha256 cellar: :any,                 sonoma:         "7d60f217be121b14522781791a9c6c2865873aec1a3fddccecea87b808f9b315"
    sha256 cellar: :any,                 ventura:        "200be1915926dac25e2afe4785f547b629db00b1e3479914d206c9136493c088"
    sha256 cellar: :any,                 monterey:       "744e5eb0caed3ef93c3b1adf66d944f4e3540f8ac08c9e24228e19f78f8072cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b00c4820f6fc1e3f13e0a072a4db0fbbf48d1d50e48f48d1f0c97d569cd128f"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "python@3.11" # Python 3.12 issue: https:github.comawsaws-cliissues8342

  uses_from_macos "mandoc"

  resource "awscrt" do
    url "https:files.pythonhosted.orgpackages6925b1c6d1c3aeed90cb6ce69a6c5136caeb7f43f8d81a87f626d6a21b082afcawscrt-0.19.19.tar.gz"
    sha256 "1c1511535dee146a6c26a382ed3ead56259a105b3b7d7d823553ae567d038dfe"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https:files.pythonhosted.orgpackages15d9c679e9eda76bfc0d60c9d7a4084ca52d0631d9f24ef04f818012f6d1282ecryptography-40.0.1.tar.gz"
    sha256 "2803f2f8b1e95f614419926c7e6f55d828afc614ca5ed61543877ae668cc3472"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackages4b89eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "docutils" do
    url "https:files.pythonhosted.orgpackages6b5c330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91fdocutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages4bbb75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415aprompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages5e0b95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46depycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
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
    url "https:files.pythonhosted.orgpackages0320630783571e76e5fa5f3e9f29398ca3ace377207b8196b54e0ffdf09f12c1setuptools-67.8.0.tar.gz"
    sha256 "62642358adc77ffa87233bc4d2354c4b2682d214048f500964dbe760ccedf102"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages0c3964487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackages7ab029c0c8c6f8cebeb0de4c17bc44365cba0b35cb4246e4a27a7e12ecf92d73wheel-0.38.1.tar.gz"
    sha256 "ea041edf63f4ccba53ad6e035427997b3bb10ee88a4cd014ae82aeb9eea77bb9"
  end

  def python3
    which("python3.11")
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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

    # The `awscrt` resource requires `setuptools` & `wheel`, so they must be installed first
    venv = virtualenv_create(libexec, "python3.11", system_site_packages: false)
    venv.pip_install resources.reject { |r| r.name == "awscrt" }
    venv.pip_install resource("awscrt")
    venv.pip_install_and_link buildpath

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