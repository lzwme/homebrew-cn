class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https:github.comuutilscoreutils"
  url "https:github.comuutilscoreutilsarchiverefstags0.0.28.tar.gz"
  sha256 "b2e8b2531c52e9b09e55a6b41a8875e5770bcea6e5fa7a01d89d7904cf292cb9"
  license "MIT"
  head "https:github.comuutilscoreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e7f020c067e4d7d7b2be14b674e6825ae7514bac2fbe715fbae458a63d468c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3424eae0c8d22ef736f54f44832aa3c8584fcab9fd8b2f487a3e790a0a80404"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ef1a909306ea91b9bbc900959193161a16ced3f85e126b15ba8692a33b00e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c9798ce2a8539c8c65c8c9bf19f4f8dc3ef2bbade89b11012455cf8af234b95"
    sha256 cellar: :any_skip_relocation, ventura:       "0297aed2325488cc048ec14db4b076e1539f18e3077430f3d24448745a013f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3cf54225e74bb6317068fb71b3ac949ee0f1ed04a5d9340433092e9effb3bb"
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

    (libexec"uubin").install_symlink "..uuman" => "man"

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