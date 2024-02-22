class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages04bd8a672a86e68f542c3f2ae17a9a8fa63babf16d1107be2f5290e5aa4369bapre_commit-3.6.2.tar.gz"
  sha256 "c3ef34f463045c88658c5b99f38c1e297abdcc0ff13f98d3370055fbbfabc67e"
  license "MIT"
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "72e590bba1f4192726ff31c75f087b2fd0abd3d5a95778b8556190e936983f8d"
    sha256 cellar: :any,                 arm64_ventura:  "87ff42485d22827787f21deecd69fff06a8accbce5cb716f5e5df355ff1da65f"
    sha256 cellar: :any,                 arm64_monterey: "043c8cd137d106a6a6afe158e50c6d5d23af773aea2cb548391289e5f2eeb931"
    sha256 cellar: :any,                 sonoma:         "8689e14658420ab0d6140c79510c8e20e6a95d2ff5446dea4d6ff91ad2e42fc3"
    sha256 cellar: :any,                 ventura:        "a61cf7daaebd7fc939ba417b0342f06a82dd026b1801cd56735442e350b337d6"
    sha256 cellar: :any,                 monterey:       "e5e6a57d2f8b3c029dddffe209386c14a9b2d9648ae3f2b9ab897c59e0b5b49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fc958ca25ba0aff9b98c845e891951fd55bba067b168628d0610a06870fd18"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "cfgv" do
    url "https:files.pythonhosted.orgpackages1174539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "identify" do
    url "https:files.pythonhosted.orgpackagesc4ba680e84c24284eba70aebaaa90d03bd039453419151b0e6f92cd36bf69dd5identify-2.5.35.tar.gz"
    sha256 "10a7ca245cfcd756a554a7288159f72ff105ad233c7c4b9c6f0f4d108f5f6791"
  end

  resource "nodeenv" do
    url "https:files.pythonhosted.orgpackages48928e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc93d74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fadsetuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages94d7adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492virtualenv-20.25.0.tar.gz"
    sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  end

  def python3
    "python3.12"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commitcommandsinstall_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}bin#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.12"].opt_binpython3
    dirs_to_fix = [libexec"libpython#{xy}"]
    dirs_to_fix << (libexec"bin") if OS.linux?
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
    (testpath".pre-commit-config.yaml").write <<~EOS
      repos:
      -   repo: https:github.compre-commitpre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin"pre-commit", "install"
    (testpath"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "usrbin:bin"
    system git_exe, "commit", "-m", "test"
  end
end