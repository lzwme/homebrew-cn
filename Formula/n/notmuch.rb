class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.1.tar.xz"
  sha256 "c1418760d0e53efad1f35267eb99a50f8b7fa2855c1473e0a4c982b86f8ecdd4"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1250c1858e453bf1daccff954b5e35a29c4dabb12a03bc7e9f58f2967f85cea7"
    sha256 cellar: :any,                 arm64_ventura:  "094732333965b4f7e5f7557a2435383c280197b63d4cd8b22f331cf7c3699bea"
    sha256 cellar: :any,                 arm64_monterey: "b61b2e6c9a2be93159d86f98769aeeb37da979882f8c55070b7d858fd0472b96"
    sha256 cellar: :any,                 sonoma:         "6f4416949a6a59dadd78610165f138056449dc70d6bcce6692849951e462a9a9"
    sha256 cellar: :any,                 ventura:        "a6ef694d92c6543a2d41ce01313a5a9e8bf33b1cbfeaefaec5f2ac56688e25c2"
    sha256 cellar: :any,                 monterey:       "c43e0c83a445e97e8cb0f664bc2e80cb706e5c9742c3a6644fa03fc21a89c0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b55ab0e65e88d8223853e349023a507768cd31054e508c73ae99f66e091c0b"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.12"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  def python3
    "python3.12"
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

    elisp.install Pathname.glob("emacs/*.el")
    bash_completion.install "completion/notmuch-completion.bash"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    ["python", "python-cffi"].each do |subdir|
      system python3, "-m", "pip", "install", *std_pip_args, "./bindings/#{subdir}"
    end
  end

  test do
    (testpath/".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}/Mail
    EOS
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", "import notmuch"

    system python3, "-c", <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      assert str(db.path) == '#{testpath}/Mail', 'Wrong db.path!'
      db.close()
    PYTHON
  end
end