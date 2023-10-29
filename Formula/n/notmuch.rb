class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.1.tar.xz"
  sha256 "c1418760d0e53efad1f35267eb99a50f8b7fa2855c1473e0a4c982b86f8ecdd4"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4af530a0937246affbc143d652be35ee2dbf54b9b352af88eb4ee5483d6d3135"
    sha256 cellar: :any,                 arm64_ventura:  "4a2a250d7f0d65cbd859b1a357a27ceb9ac826405cd620f301b329b9982a385f"
    sha256 cellar: :any,                 arm64_monterey: "bbb73975aeb66a3763bb5ffed408bc5b53414f63e23282b4b0b0444bbfec3314"
    sha256 cellar: :any,                 sonoma:         "24390fb332a8bf7b61e5c849878984d49b8e8a814cfeba991228668bdc98946d"
    sha256 cellar: :any,                 ventura:        "4b230b0402daef4ac2429217b3163cec65f3a5ab4e950b2f8779bc07d6188bae"
    sha256 cellar: :any,                 monterey:       "281ef6e41b34e9b29bcad8becd0a80c7b4f02221ee4e18d5beb0428a08aba1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff756e68ca27d66f4fd9a24df031ad4f1d630de92468be6cce4673fd105895bc"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.11"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  def python3
    "python3.11"
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