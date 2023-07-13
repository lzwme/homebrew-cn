class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://github.com/uutils/coreutils"
  url "https://ghproxy.com/https://github.com/uutils/coreutils/archive/0.0.19.tar.gz"
  sha256 "c21564fbbe0d4742290f98badaebfec54177c42dbfe755c30997a088d9897060"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3b88600562638f4a11016b1e504664238b62958b37c528b9948ea5359b1d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52bc0e887bd9e0c5e5959de85ba29cd4068861bc6e00cd1b986c81412e0d8d7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43c14a34f7d862a4f3cba0abbaaa112eced5bed0a87540eaee3f6ec69d361320"
    sha256 cellar: :any_skip_relocation, ventura:        "fa587a65789ab3d13fd7cd86d174e013240224066abbd264eae9b977e27e5754"
    sha256 cellar: :any_skip_relocation, monterey:       "4e56ee311116f8fa35244adb5c6b34677c0d10f84196e8b00785464e07036e9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "15f62abb16eeb8d718c7557c2f5f9256703b68eb8087d4dde59b755b85145cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e24b78cd9f796869b0a4108d00985de7c07faf53cef04be4efa7d034ecdf3d1b"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
    conflicts_with "truncate", because: "both install `truncate` binaries"
  end

  def install
    man1.mkpath

    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake", "install",
           "PROG_PREFIX=u",
           "PREFIX=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"

    # Symlink all commands into libexec/uubin without the 'u' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"uubin").install_symlink bin/"u#{cmd}" => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'u' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman"/"man1").install_symlink man1/"u#{cmd}" => cmd
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