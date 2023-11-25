class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/04/b3/4ae08d21eb097162f5aad37f4585f8069a86402ed7f5362cc9ae097f9572/pre_commit-3.5.0.tar.gz"
  sha256 "5804465c675b659b0862f07907f96295d490822a450c4c40e747d0b1c6ebcb32"
  license "MIT"
  revision 2
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0dde82b5299825fbcbbdf61b5a81c56619a4bf7e1360dd7385df0e8e5db99bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6beb68d2670d28316cf24cbce3a3ae60d6857fb450a502d8656ca03179bc0298"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "907bbbc2593791b22019f09b757a42e652b35f55dfb63330f184dcdd0039203e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ac82609c12dc9a96c8010984da85e88e274819dbb72f1ffef3cf841308c03d1"
    sha256 cellar: :any_skip_relocation, ventura:        "cb6e2e31a94a2eeafa0d34d710d049bd0e5defcde117ad861b061687c865c83b"
    sha256 cellar: :any_skip_relocation, monterey:       "5f26e6b8c1353365ca7eb58ebe36ed46c20bf54fad0fd6b03052f33b97e6fae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb1b58f6c29cb58d6cfeaebc5285ba9b9f1166518ad248b8ab65a46c9903335"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/cb/d7ca096a5bea337db7bcca03afd18c4a7fe502ba1b0c64915950c37a5d41/identify-2.5.32.tar.gz"
    sha256 "5d9979348ec1a21c768ae07e0a652924538e8bce67313a73cb0f681cf08ba407"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
  end

  def python3
    "python3.12"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.12"].opt_bin/python3
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end