class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https:github.comuutilscoreutils"
  url "https:github.comuutilscoreutilsarchiverefstags0.0.23.tar.gz"
  sha256 "cb10a4790e80900345db9a4a929d36ab0d6bb0a81cd3427730300cbae5be9178"
  license "MIT"
  head "https:github.comuutilscoreutils.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c21c54c390e33d18ed11da609fb254d90931dbb616bf33f69503a7f34c502b25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a85b17e313184c628139bfc2742b7019e5e5273661abd48141f4bfd2fa7c868c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d2a17724a16d13678497f691387abd9e4dd26d0d6f70867d0f10282fa6b56a"
    sha256 cellar: :any_skip_relocation, sonoma:         "171fe1ab2ba97f3135049bcca932bbe4ea60f87095c5157103e87e1da01c7de4"
    sha256 cellar: :any_skip_relocation, ventura:        "38e67fe68447e0188f29ae2c87bb1faec8e956d69b7578ef31fb292802609565"
    sha256 cellar: :any_skip_relocation, monterey:       "68dcdeabf9fb887af11cc35fc6e68bf33b61d1eb749a9254689c6f6b3fa58eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21194076ba62dfa0bb1f6fdd59df5f2043283db8a5639f8bfea41860056b4a1e"
  end

  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  on_macos do
    conflicts_with "coreutils", because: "uutils-coreutils and coreutils install the same binaries"
    conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  end

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