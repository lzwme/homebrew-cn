class Pgformatter < Formula
  desc "PostgreSQL syntax beautifier"
  homepage "https://sqlformat.darold.net/"
  url "https://ghfast.top/https://github.com/darold/pgFormatter/archive/refs/tags/v5.7.tar.gz"
  sha256 "5da983424cb4f36b31daaff8ecfdae4e5cefb7a7a27923474699348fcabc6e58"
  license "PostgreSQL"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "620f2f0447136cd3da98aad631d9e4eb6df2f555ff6b0d17ec822a09e532590f"
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=.", "MAN1EXT=1"
    system "make", "install"

    if OS.linux?
      # Move man pages to share directory so they will be linked correctly on Linux
      mkdir "usr/local/share"
      mv "usr/local/man", "usr/local/share"
    end

    prefix.install (buildpath/"usr/local").children
    (libexec/"lib").install "blib/lib/pgFormatter"
    libexec.install bin/"pg_format"
    bin.install_symlink libexec/"pg_format"

    # Build an `:all` bottle
    rm_r share/"perl" if OS.linux?
    chmod 0755, [bin, share, share/"man", man1, man3] # permissions match
  end

  test do
    test_file = (testpath/"test.sql")
    test_file.write("SELECT * FROM foo")
    system bin/"pg_format", test_file
  end
end