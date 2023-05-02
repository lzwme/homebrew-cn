class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/20/39/b661d2bf936fb24f5bac50f1717d59ef4fe04813f84cac109e9edc0a04c2/pre_commit-3.3.0.tar.gz"
  sha256 "06acda43a7b6b63fdcc29aa90bf1228cf4d4029a4e4d70971347a9d2593c94d4"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "219728ed4d5937a1c6ffb1764813eac64ef131006f18b4b6051b593366733293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b877169d224459ebc8db84a5aeb694d50d0541f5099717b960c5474cae2d6404"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d9fa1a892abb64f9c43818e1827cca12beb96f6679de7ea5c271c29283cd6f6"
    sha256 cellar: :any_skip_relocation, ventura:        "834027de2487db27dd0947c43513fcfc7f313652c8b52cc970bc901854f12b58"
    sha256 cellar: :any_skip_relocation, monterey:       "761df06e35423b9c36fe397633b1637d47f0ddfdfcb8c0b29ec94efb7eceb112"
    sha256 cellar: :any_skip_relocation, big_sur:        "6170156a289b7a83aa4b59051d9c47c1b23191393eefaaecb4ae96384be968b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edd8c34fca504aa2ded44450fad24cfd5cf15e3c8ecd6ee20b88a2437d5655dd"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/7c/97/16fcc4ecb2b56217cfbd9d7b141c13e6c1c84910c0045ba83d9fed3ba65e/identify-2.5.23.tar.gz"
    sha256 "50b01b9d5f73c6b53e5fa2caf9f543d3e657a9d0bbdeb203ebb8d45960ba7433"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/f3/9d/a28ecbd1721cd6c0ea65da6bfb2771d31c5d7e32d916a8f643b062530af3/nodeenv-1.7.0.tar.gz"
    sha256 "e0e7f7dfb85fc5394c6fe1e8fa98131a2473e04311a45afb6508f7cf1836fa2b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/91/17/3836ffe140abb245726d0e21c5b9b984e2569e7027c20d12e969ec69bd8a/platformdirs-3.5.0.tar.gz"
    sha256 "7954a68d0ba23558d753f73437c55f89027cf8f5108c19844d4b82e5af396335"
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