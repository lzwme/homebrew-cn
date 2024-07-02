class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https:github.comuutilscoreutils"
  url "https:github.comuutilscoreutilsarchiverefstags0.0.27.tar.gz"
  sha256 "28d537a5210e8593ff30c566192c7f63eb60db9ae76cd4612c2ab131e2c112d2"
  license "MIT"
  head "https:github.comuutilscoreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47bf5d6da2c20407501b7c04c088169af6513d57a220d7bbd9c05a98b66bd6be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdb31d33a9a5f9e743aecb9ade9225318fe87c3e294ae194a42d462303911d0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40ee6ad5d869e5dde1e264071e68050a0a99fa2e91c7e580ee179dc5ac84353f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1c9173b45be2281192e6df13ae6cf2220220ee6d0e4b9b40f05f2719dc9cef9"
    sha256 cellar: :any_skip_relocation, ventura:        "851771063a73cbca9a5ca406f6e711a245c85777f55bef78e238edeaff80f1ad"
    sha256 cellar: :any_skip_relocation, monterey:       "76fb8c11b4c29ae02ceb354cce3cf8b8f3d46f1e1367015627df4b885f2a36f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa550c5382a9570c994051c2d673687370a758b04c95af69d7e0cc507ab2e26"
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