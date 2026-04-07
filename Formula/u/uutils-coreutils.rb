class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://ghfast.top/https://github.com/uutils/coreutils/archive/refs/tags/0.8.0.tar.gz"
  sha256 "03f765fd23e9cc66f8789edc6928644d8eae5e5a7962d83795739d0a8a85eaef"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07738f6acd80648d3f46702a39d735d1a7c59f9b3f4f60f89b350feeb349290c"
    sha256 cellar: :any,                 arm64_sequoia: "21b75dce554d38c812f1336596d317425c81130cdbd58f87a1569765ae300075"
    sha256 cellar: :any,                 arm64_sonoma:  "67d5f6cea919010ab137a46a73f28820618322cfb2f6459335487615e076524a"
    sha256 cellar: :any,                 sonoma:        "d6c1cb07fc62c56308f385548dfb0e73fd07a742bdd5d8007234cf8ebb2f743e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "361b414f867af5410d2d2a144bede1e0c8559622f2e1a98f171ea0c53a147974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59701cdc8555d1d0cdd67534a57135ecf7fb4c1a50be99911c55c051af289e8"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    man1.mkpath

    # Prevent to add a feature for `selinux`
    inreplace "GNUmakefile", "$(SELINUX_PROGS)", ""

    args = %W[
      PROG_PREFIX=uu-
      PREFIX=#{prefix}
      SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
    ]
    system "make", "install", *args

    # Symlink all commands into libexec/uubin without the 'uu-' prefix
    coreutils_filenames(bin).each do |cmd|
      uu_cmd = bin/"uu-#{cmd}"
      (libexec/"uubin").install_symlink uu_cmd.realpath => cmd
    end

    # Symlink all man(1) pages into libexec/uuman without the 'uu-' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"uuman/man1").install_symlink man1/"uu-#{cmd}" => cmd
    end

    (libexec/"uubin").install_symlink "../uuman" => "man"
  end

  def caveats
    <<~EOS
      Commands have been installed with the prefix "uu-".
      If you need to use these commands with their normal names, you
      can add a "uubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/uubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^uu-/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"uu-sha1sum", "-c", "test.sha1"
    system bin/"uu-ln", "-f", "test", "test.sha1"
  end
end