class UutilsCoreutils < Formula
  desc "Cross-platform Rust rewrite of the GNU coreutils"
  homepage "https://uutils.github.io/coreutils/"
  url "https://ghfast.top/https://github.com/uutils/coreutils/archive/refs/tags/0.11.0.tar.gz"
  sha256 "a47966117783bef18650cc724f1b1d061b717ac91a0feaabdd34910703cf70a4"
  license "MIT"
  head "https://github.com/uutils/coreutils.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1be42be4b24c8b26bf7fafd464671d21a14ad0a1bb452f06eb03bd1dcc94ff94"
    sha256 cellar: :any, arm64_sequoia: "b70a34a29e55591472c59b74bb56093ba42c02504aca7488555fa2cadfa2f105"
    sha256 cellar: :any, arm64_sonoma:  "12d799a82502002df1bf7ca9ab3e26f5a59bdf696ec024eeb1056ddce5d76380"
    sha256 cellar: :any, arm64_linux:   "6fd365901b4b48ba97a91b3c7d19800cded910a1570b79c30445ee35a7b23675"
    sha256 cellar: :any, x86_64_linux:  "55cb91bd524c38b57455e38c54b10b163291b59a0766f959fe6665a3dc9efa34"
  end

  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build

  def install
    man1.mkpath

    args = [
      "PROG_PREFIX=uu-",
      "PREFIX=#{prefix}",
      "SPHINXBUILD=#{formula_opt_bin("sphinx-doc")}/sphinx-build",
      "MULTICALL=y",
      "LN=ln -sf",
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