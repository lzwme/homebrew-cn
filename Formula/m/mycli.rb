class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/ac/4d/513ada515b77c5a2d7eafd9b05f3f44965bad18fc494f6733531721c867b/mycli-1.34.0.tar.gz"
  sha256 "a22b172171d8d4ac78be5e7729d5a73b0e891eb96117d8bcaf30c5d725b3ec4d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0543476bd7027c82b041ee14ff4cc38afcd7598e863864a48d07248d129534ac"
    sha256 cellar: :any,                 arm64_sonoma:  "05a19af9c96677dd4178b21b46a1a7182ac78e7fe92aa9488c8ec1e9ba0e2262"
    sha256 cellar: :any,                 arm64_ventura: "ab74a1bb6b8cd6869ec91c928c399ad0c05b3640748b9501d635e2d5703a9696"
    sha256 cellar: :any,                 sonoma:        "e9687f422281c13afd25db2729d601b0da9b57ee6b37202bf4a2dd2fad3afa96"
    sha256 cellar: :any,                 ventura:       "81240732bbd51dedacba6ed3f802743280e695bf57f2e05e7c13117c1e19207a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2026e4475856cf7e748312ad77d3a32afe71a5e33aa39ebef4aab8ae3c58d008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e617655e6f4ad6a132febe2bf1a044a497102af2a0c8d8be02b77ad164749ce9"
  end

  depends_on "rust" => :build # for sqlglotrs
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/b8/3c/fcc24843edb6f0f52706a85886c240a6a7e7b143bfe9b18463dd4be2d33d/cli_helpers-2.5.0.tar.gz"
    sha256 "7c353f8ad97f07c036c5a355007c335dc8b1d90ce1333570ea50384fb0c00e38"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pyfzf" do
    url "https://files.pythonhosted.org/packages/d4/4c/c0c658a1e1e9f0e01932990d7947579515fe048d0a515f07458ecd992b8f/pyfzf-0.3.1.tar.gz"
    sha256 "dd902e34cffeca9c3082f96131593dd20b4b3a9bba5b9dde1b0688e424b46bd2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/b3/8f/ce59b5e5ed4ce8512f879ff1fa5ab699d211ae2495f1adaa5fbba2a1eada/pymysql-1.1.1.tar.gz"
    sha256 "e127611aaf2b417403c60bf4dc570124aeb4a57f5f37b8e95ae399a42f904cd0"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/25/9d/fcd59b4612d5ad1e2257c67c478107f073b19e1097d3bfde2fb517884416/sqlglot-26.33.0.tar.gz"
    sha256 "2817278779fa51d6def43aa0d70690b93a25c83eb18ec97130fdaf707abc0d73"
  end

  resource "sqlglotrs" do
    url "https://files.pythonhosted.org/packages/59/13/e77dcfd72b849a113bea7ccee79329f77751704e66560410176b1f4657f9/sqlglotrs-0.6.1.tar.gz"
    sha256 "f638a7a544698ade8b0c992c8c67feae17bd5c2c760114ab164bd0b7dc8911e1"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"mycli", shells:                 [:fish, :zsh],
                                                      shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end