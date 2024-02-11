class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https:pre-commit.com"
  url "https:files.pythonhosted.orgpackages1fa737bb57af1681e945c0f4237a6f2da562bc54dd42db103ee9f6b41a958289pre_commit-3.6.1.tar.gz"
  sha256 "c90961d8aa706f75d60935aba09469a6b0bcb8345f127c3fbee4bdc5f114cf4b"
  license "MIT"
  head "https:github.compre-commitpre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e484a05a5bd384af65102fe822ce5376b77f638a5d48e774e5bf890a5ce1426"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d291393de358a7d20a58f050a74cc7d53bfda3e1f5627fbdee8738df8cfd599c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a424636b2204c8956ba089dcecc0ebc8bccaa8cdb3e61e34a7c6c1bd32f236a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2525c44b30d94e9f5e517aca09835c2a3c94930cc46ea09a761b8909c38ae55"
    sha256 cellar: :any_skip_relocation, ventura:        "9a2a9c8f2708d500cc8b1f08fdb1d19f09722028f4fc0d0d516b055697073e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "d87f9614307145e6a5572c37d7c86ad6062f7da75e13b3b98229ce2787524509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2febc58717f13ffbd9295870b4567ce97c453466871674d16181d7431b235e5d"
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

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
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