class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://ghproxy.com/https://github.com/aws/aws-cli/archive/2.11.24.tar.gz"
  sha256 "c6be356cf35a4c70f1dbabf743f61a67297ee024769365e08d874d28b7b4809d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b9e0cd50a46f758c45f32ded074455234c3bfe1971681cc0b8843c371e81630"
    sha256 cellar: :any,                 arm64_monterey: "e3624c6a957162b9cba4bb31e5b38a71e8c7c4dc850255c1d1999e186dcac35b"
    sha256 cellar: :any,                 arm64_big_sur:  "0a82181bb8cc7a3c0ecbd0b3222a3fb03e9cf53ef925ecfdca4448a02332c1be"
    sha256 cellar: :any,                 ventura:        "d2ebdcd675805dfa19634d9affdfbf6d4d29c464f4c5c7a3ede677fdf8d396b7"
    sha256 cellar: :any,                 monterey:       "da0e808ffadb4983d8916c93512f3e06331bf87f122ea06d107e8b15819003a1"
    sha256 cellar: :any,                 big_sur:        "4c38c8c74f3e4db24bac355f7eb626405048691a4bbb4ef7324e46e6891c5d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5c95b3a3c53f379cf25cd3232537f5a3dc7ec46231ec535cf76f13032e71f8"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "docutils"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "mandoc"

  # Python resources should be updated based on setup.cfg. One possible way is:
  # 1. Run `pipgrip 'awscli @ #{url}' --sort`
  # 2. Ignore `docutils` and `six`. Update all other PyPI packages

  resource "awscrt" do
    url "https://files.pythonhosted.org/packages/24/73/d656729a61eceabbbf4fcee3b51bf298c5edbb0a5578542121150e957ee0/awscrt-0.16.16.tar.gz"
    sha256 "13075df2c1d7942fe22327b6483274517ee0f6ae765c4e6b6ae9ef5b4c43a827"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/15/d9/c679e9eda76bfc0d60c9d7a4084ca52d0631d9f24ef04f818012f6d1282e/cryptography-40.0.1.tar.gz"
    sha256 "2803f2f8b1e95f614419926c7e6f55d828afc614ca5ed61543877ae668cc3472"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def python3
    which("python3.11")
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Temporary workaround for Xcode 14's ld causing build failure (without logging a reason):
    # ld: fatal warning(s) induced error (-fatal_warnings)
    # Ref: https://github.com/python/cpython/issues/97524
    ENV.append "LDFLAGS", "-Wl,-no_fixup_chains" if DevelopmentTools.clang_build_version >= 1400

    # The `awscrt` package uses its own libcrypto.a on Linux. When building _awscrt.*.so,
    # Homebrew's default environment causes issues, which may be due to `openssl` flags.
    # This causes installation to fail while running `scripts/gen-ac-index` with error:
    # ImportError: _awscrt.cpython-39-x86_64-linux-gnu.so: undefined symbol: EVP_CIPHER_CTX_init
    # As workaround, add relative path to local libcrypto.a before openssl's so it gets picked.
    if OS.linux?
      python_version = Language::Python.major_minor_version(python3)
      ENV.prepend "CFLAGS", "-I./build/temp.linux-x86_64-#{python_version}/deps/install/include"
      ENV.prepend "LDFLAGS", "-L./build/temp.linux-x86_64-#{python_version}/deps/install/lib"
    end

    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm bin.glob("{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}")
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
    site_packages = libexec/Language::Python.site_packages(python3)
    assert_includes Dir[site_packages/"awscli/data/*"], "#{site_packages}/awscli/data/ac.index"
  end
end