class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/97/2e/2b98f5b910fe0e6a22ad8ec6d6923427e4d3a298c73a76554b766faad10e/mycli-1.35.0.tar.gz"
  sha256 "01d007d4888ded667efc7dc38f021c55b18c8d2bd7566b99d1d4ed68bc31f989"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b1d01c087147a6a52d7547fe3e21ce0a2de1653ec412309f59382252e9184d39"
    sha256 cellar: :any,                 arm64_sonoma:  "b0e6542f747a44e246f62e0c44ff80a195a9c77904caa6fc9bb2ca71c91c40da"
    sha256 cellar: :any,                 arm64_ventura: "649cc078ac53b947ecb98545ed27fccdd199a575d2d331e573aaeaafd66af8bc"
    sha256 cellar: :any,                 sonoma:        "0c0bf2b6f51ca1a68694f6567a272920de81add9053aea696d17f36a7d77235f"
    sha256 cellar: :any,                 ventura:       "f7144fd0ac028ececc31bd6396501c02d9cd43081d6092674d53fc4663c88049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94f5a78f75a9f2b61d6b6980498f72d8108d6e56ce0c94fc142c4fac500e2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca6a6ded98825851972fc1286b82e1fa63c20512cb39428430491438551132fc"
  end

  depends_on "rust" => :build # for sqlglotrs
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/a3/a7/22abd67bccf39835df3fbc97ba2541d26ba2c723f3066ebf4a024df8d2a5/cli_helpers-2.6.0.tar.gz"
    sha256 "1d37659ebb4eb5e2ebecd8a148ba2698eb7da62b34d63124bf5ce7ff3c4d413f"
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

    generate_completions_from_executable(bin/"mycli", shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end