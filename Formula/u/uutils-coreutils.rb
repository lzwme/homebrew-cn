class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https:github.comuutilscoreutils"
  url "https:github.comuutilscoreutilsarchiverefstags0.0.27.tar.gz"
  sha256 "3076543a373c8e727018bd547cc74133f4a6538849e4990388f2bbea9a9aff6b"
  license "MIT"
  head "https:github.comuutilscoreutils.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "909f65abde6d575efbd663905b1af083ee02b6ee3dbf9785838403a1ed48c0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9513777efc24f8f5afa53b26512303c24644472982be1e9409e43ae5c5c3b315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5981c792d41976b5478ae9d7abcc6254913c3f830986fac7762900f5e5904918"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f329b6db2133f8fd9cc382fcfc638db824a3ea192bde0419ad661ea4c433738"
    sha256 cellar: :any_skip_relocation, ventura:        "16d1a6e842797a06f97ff64d43290b1fc4a9d5abb08eef0a62fb539cf66bfa2b"
    sha256 cellar: :any_skip_relocation, monterey:       "039454774e3ebb1f6e658b725d43c829dede270ea56b21dab9e6b6d2c53f4875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95279f741499a4d83312ac28ce40bf1a260bb30e23cbeb545475f7348159c77a"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  end

  conflicts_with "unp", because: "both install `ucat` binaries"

  def install
    man1.mkpath

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install",
           "PROG_PREFIX=u",
           "PREFIX=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}sphinx-build"

    # Symlink all commands into libexecuubin without the 'u' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec"uubin").install_symlink bin"u#{cmd}" => cmd
    end

    # Symlink all man(1) pages into libexecuuman without the 'u' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec"uuman""man1").install_symlink man1"u#{cmd}" => cmd
    end

    libexec.install_symlink "uuman" => "man"

    # Symlink non-conflicting binaries
    no_conflict = if OS.mac?
      %w[
        base32 dircolors factor hashsum hostid nproc numfmt pinky ptx realpath
        shred shuf stdbuf tac timeout truncate
      ]
    else
      %w[hashsum]
    end
    no_conflict.each do |cmd|
      bin.install_symlink "u#{cmd}" => cmd
      man1.install_symlink "u#{cmd}.1.gz" => "#{cmd}.1.gz"
    end
  end

  def caveats
    provided_by = "coreutils"
    on_macos do
      provided_by = "macOS"
    end
    <<~EOS
      Commands also provided by #{provided_by} have been installed with the prefix "u".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}uubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(^u, "")
    end
    filenames.sort
  end

  test do
    (testpath"test").write("test")
    (testpath"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin"uhashsum", "--sha1", "-c", "test.sha1"
    system bin"uln", "-f", "test", "test.sha1"
  end
end