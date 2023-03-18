class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/59/5d/157a051b2a402d7d27eb7c478fd7c1a231b94779054b3d7aef1719378e2d/pre_commit-3.2.0.tar.gz"
  sha256 "818f0d998059934d0f81bb3667e3ccdc32da6ed7ccaac33e43dc231561ddaaa9"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37fad7396b7344f94d7596cfdbdfdae03a792fead4204e3baa67e72c596aa2c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37fad7396b7344f94d7596cfdbdfdae03a792fead4204e3baa67e72c596aa2c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37fad7396b7344f94d7596cfdbdfdae03a792fead4204e3baa67e72c596aa2c6"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb8d2639bae8880f0f09eeb8080a2a89e4d91f47ea186b2c33d1894fd92a4da"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb8d2639bae8880f0f09eeb8080a2a89e4d91f47ea186b2c33d1894fd92a4da"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb8d2639bae8880f0f09eeb8080a2a89e4d91f47ea186b2c33d1894fd92a4da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22658172de8b255c98a47e4c0bb6f8a467934f1d2bf0885aeb360641da6c762"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/85/0d/5d875ec52e1a0b8290d5cf1995f1afc9f6830146b8c6565d800b47522e46/identify-2.5.21.tar.gz"
    sha256 "7671a05ef9cfaf8ff63b15d45a91a1147a03aaccb2976d4e9bd047cbbc508471"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/f3/9d/a28ecbd1721cd6c0ea65da6bfb2771d31c5d7e32d916a8f643b062530af3/nodeenv-1.7.0.tar.gz"
    sha256 "e0e7f7dfb85fc5394c6fe1e8fa98131a2473e04311a45afb6508f7cf1836fa2b"
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