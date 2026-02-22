class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.40.tar.xz"
  sha256 "4b4314bbf1c2029fdf793637e6c7bb15c1b1730d22be9aa04803c98c5bbc446f"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cafbd5ffd9eb60479b8edf50891ec9f2b08bdd21e146f5f04eda782480db75b8"
    sha256 cellar: :any,                 arm64_sequoia: "63cdd5c3afdff3c28ee8f2a5fa3fa413f4bf4553bace983239cbef29a01763af"
    sha256 cellar: :any,                 arm64_sonoma:  "05cf2893b94f0e0480d2f630b47bc442d62d14141609ae5f49a5c43448bdda13"
    sha256 cellar: :any,                 sonoma:        "d9237123ce3a5e4f3ccac403836f39f800c15e4868d17ca1ad01ba8192e16146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "259509347674489fc0f424df7e95590b5ee9f6b878a8a8b22d74a6f239f3c18f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1adead0a4a2502fd61aeace8890dee06054263d4c6fae6a783af826cb3cccb6"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "gnupg" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.14"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
  end

  def install
    ENV.cxx11 if OS.linux?
    site_packages = Language::Python.site_packages(python3)
    with_env(PYTHONPATH: Formula["sphinx-doc"].opt_libexec/site_packages) do
      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}",
                            "--emacslispdir=#{elisp}",
                            "--emacsetcdir=#{elisp}",
                            "--bashcompletiondir=#{bash_completion}",
                            "--zshcompletiondir=#{zsh_completion}",
                            "--without-ruby"
      system "make", "V=1", "install"
    end
    bin.install "notmuch-git"
    rewrite_shebang detected_python_shebang, bin/"notmuch-git"

    elisp.install Pathname.glob("emacs/*.el")
    bash_completion.install "completion/notmuch-completion.bash" => "notmuch"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/python-cffi"
  end

  test do
    (testpath/".notmuch-config").write <<~INI
      [database]
      path=#{testpath}/Mail
    INI
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      assert str(db.path) == '#{testpath}/Mail', 'Wrong db.path!'
      db.close()
    PYTHON
    system bin/"notmuch-git", "-C", testpath/"git", "init"
    assert_path_exists testpath/"git"
  end
end