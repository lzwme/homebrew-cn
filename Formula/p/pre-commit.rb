class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages88e84330d06f2b00ad3a9c66e07a68fe23f70233a4e7e1aaba5a738a93d2cb5dpre_commit-3.6.0.tar.gz"
  sha256 "d30bad9abf165f7785c15a21a1f46da7d0677cb00ee7ff4c579fd38922efe15d"
  license "MIT"
  revision 1
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6161f704e6ca2e2a7c1acbb83cac70098859da72c4a15006aa8733bd7e07ecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c6ced4a6600e687dc72d355cc5ef94be288fb547a55b70acfc5efb486664109"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0285edf6b382de81964ac89928aa0e802f890f82fc275e5b892d613db6954f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cdf80ea29797cd1a7e737eee1cb532da851e87be208b37c536a1c4e0ae3ed60"
    sha256 cellar: :any_skip_relocation, ventura:        "282e026682a1ceaf2b797b30c20e3cf4eaa7a9742458f653897bba18002b87a4"
    sha256 cellar: :any_skip_relocation, monterey:       "75527b653175ea474f154cb44d6640b6c4445fac901d082492dc1f4f562a1bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a0f913cd2eb408d43ae82d0bf8346918e8aa86730024018eb17bf997523bfa"
  end

  depends_on "python-setuptools" # remove with nodeenv>1.8.0
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "virtualenv"

  resource "cfgv" do
    url "https:files.pythonhosted.orgpackages1174539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "identify" do
    url "https:files.pythonhosted.orgpackages61a092aba7e128faadab9db785c1f8cc442caf51cba5a55b575abb211b12526fidentify-2.5.33.tar.gz"
    sha256 "161558f9fe4559e1557e1bff323e8631f6a0e4837f7497767c1782832f16b62d"
  end

  resource "nodeenv" do
    url "https:files.pythonhosted.orgpackages48928e83a37d3f4e73c157f9fcf9fb98ca39bd94701a469dc093b34dca31df65nodeenv-1.8.0.tar.gz"
    sha256 "d51e0c37e64fbf47d017feac3145cdbb58836d7eee8c6f6d3b6880c5456227d2"
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

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexecsite_packages"homebrew-virtualenv.pth").write virtualenvsite_packages
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