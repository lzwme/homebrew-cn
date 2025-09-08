class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://ghfast.top/https://github.com/uutils/coreutils/archive/refs/tags/0.2.0.tar.gz"
  sha256 "185be1670bb5091f48d29524c6f81326f12aef5e599fcdb122967a95d017f32a"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "912680e848466669cbb65c3e744a5b96e240da36cb32d516b0d0a0db87ea26c3"
    sha256 cellar: :any,                 arm64_sonoma:  "cc1830b49fe485cf5c2666bdaca9dc7ed967c6054d803ca4dc9bbfaf007b51bb"
    sha256 cellar: :any,                 arm64_ventura: "a7725e305b7890270eb1c3b6870ea6524e9b926a58ecf75d630a75dda34fd6a2"
    sha256 cellar: :any,                 sonoma:        "02f4f2934ebe230f37a86cbc8d296a3472d8db5de26505b0dc7f175e844f4aee"
    sha256 cellar: :any,                 ventura:       "3b9a44d6cec1f7c06697c328b8c8275b854d04df4ef4b03ff02d979cd8a77cea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61f30b0be733a2c05cceb2b16d277612a5d7c1505c1609a886f94ff35019b276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf9bc9639ed4dfffddb9ee58d8fd0ec95e54e1175288e65aed831b650cb774d"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
  end

  conflicts_with "unp", because: "both install `ucat` binaries"

  def install
    man1.mkpath

    # Prevent to add a feature for `selinux`
    inreplace "GNUmakefile", "$(SELINUX_PROGS)", ""

    args = %W[
      PROG_PREFIX=u
      PREFIX=#{prefix}
      SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
    ]
    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install", *args

    # Symlink all commands into libexec/uubin without the 'u' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"uubin").install_symlink bin/"u#{cmd}" => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'u' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman"/"man1").install_symlink man1/"u#{cmd}" => cmd
    end

    (libexec/"uubin").install_symlink "../uuman" => "man"

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
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^u/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"uhashsum", "--sha1", "-c", "test.sha1"
    system bin/"uln", "-f", "test", "test.sha1"
  end
end