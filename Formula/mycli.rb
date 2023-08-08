class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/d6/e9/e3555839dec9ddbb94e20e5f5b7b633efc603986cffe1113f99048306887/mycli-1.26.1.tar.gz"
  sha256 "8c03035c9b4526dbfa0b0859654e2974a0e77592a9e9b27f40f5a8daae83beb1"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bf1e5db515be8c9551a556b3c24cea566f9da98dbf62d9897a046a115c0b633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb3ede7492fb5ebf804dd6b4b94f7caa58560fa7f0b8bf41a6726739d8c82fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dd4259f0f47869beef530ddc4caf8847a906a20d7438797f372f63b00404122"
    sha256 cellar: :any_skip_relocation, ventura:        "935e5bf279c2da81c06acb27837eb715f6fea39d096f58b667ad4f31a577ed20"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba1e8fdf01bc1973100a9e02b68ae57a4d5ee9072ea94142f05ba5cab231fa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bfd2a17e2ce378f5426ab6b628b14eecc5b1e444bfba2d592b10cb5540e3921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56fda4cb7bebd869875d8b08d1d3d2b540beee0f6e9a1b16fef2b71e83eb6353"
  end

  depends_on "cffi"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/4e/a2/3cab1de83f95dd15297c15bdc04d50902391d707247cada1f021bbfe2149/importlib_resources-5.12.0.tar.gz"
    sha256 "4be82589bf5c1d7999aedf2a45159d10cb3ca4f19b2271f8792bc8e6da7b22f6"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/7a/6f/b3fadf41239b9ca7ea3857c440c499fd2e9e0f410bb942bd8d593dce4bd6/PyMySQL-1.0.3.tar.gz"
    sha256 "3dda943ef3694068a75d69d071755dbecacee1adf9a1fc5b206830d2b67d25e8"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/94/0b/69ee9183fd6598bfb0de087dec5231a6282eccf2565aca761892b1427b81/sqlglot-11.6.0.tar.gz"
    sha256 "c7e6cb1f70b51a8fc167536cbe2abe3ac120e500905d8fc9be5dc89a20cbd006"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
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