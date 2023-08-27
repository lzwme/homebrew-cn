class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/35/0e/564c71fe3cdf59a4acaaccaea354d066e5d9044eba564dac070bb2075432/pre_commit-3.3.3.tar.gz"
  sha256 "a2256f489cd913d575c145132ae196fe335da32d91a8294b7afe6622335dd023"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3746f6680c81b4a29838ee475fa6e91b8002bfa99cd47354bf72c9ee67c992a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c192c95494d2642c36089266fda3b2bc68188bfa6bc1d01b9713cb18626d4dd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d1dee53315a82c8d1c09867e403aee9715158d597a17aa408f0e61d84af0c1d"
    sha256 cellar: :any_skip_relocation, ventura:        "8a683803130f937d198a6c29173d14635751f347d63fa0304a5e75178dca435a"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc8914225646c789d5112660f4409508f1e22779bbeba91692010df8ddf027a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c86e65d7fc7e0d1d2d56ab64f7ade2f81b899b194e8eb1209602fcaefde082f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a394b13bf4b150733c3e3861d79c9109d3c8b3343dccd84f14ad45e55c9181d"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e0/7e/dc9ae38e2944611174051371e62cb79a9fd98fd8b4e4f07d0c1fbf2bb260/identify-2.5.27.tar.gz"
    sha256 "287b75b04a0e22d727bc9a41f0d4f3c1bcada97490fa6eabb5b28f0e9097e733"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/48/92/8e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65/nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
  end

  def python3
    "python3.11"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.11"].opt_bin/python3
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