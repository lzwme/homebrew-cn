class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/04/b3/4ae08d21eb097162f5aad37f4585f8069a86402ed7f5362cc9ae097f9572/pre_commit-3.5.0.tar.gz"
  sha256 "5804465c675b659b0862f07907f96295d490822a450c4c40e747d0b1c6ebcb32"
  license "MIT"
  revision 1
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6043fea5396b85b6c44713a20e56aadc35b08aca67dc60aaff90dd4f7973dc1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e8c220af41070fe067f7096929011aa8b0318bd48450245b5be5a624c5ae653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33b665aafcdd7dccb01fb6853937ffd603d75a83955fb4f005c13c5e4bf69a72"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fdcb07e81e5460be10fd7d929469944e2b3892ebf5deca241070144e9d09c8e"
    sha256 cellar: :any_skip_relocation, ventura:        "7a7219a65f572b63fab969a7af7b4ea5009bca4b33173a4eb164834fcff2359b"
    sha256 cellar: :any_skip_relocation, monterey:       "7f2b56bf97b7f05043ecda1f1e64e396e065ec2da9bd6d45b854f159b189dbdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26aa23bf87c5a1f961b179a26e6ff7d9fb1b9d81ff8754c8c7858a4ccb4cba0a"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/5f/19/f3aa63b65be4cdf23ba26984aa04cb21fa04fccfef68355919edafee025c/identify-2.5.30.tar.gz"
    sha256 "f302a4256a15c849b91cfcdcec052a8ce914634b2f77ae87dad29cd749f2d88d"
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