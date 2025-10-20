class FennelLs < Formula
  desc "Language Server for Fennel"
  homepage "https://git.sr.ht/~xerool/fennel-ls/"
  url "https://git.sr.ht/~xerool/fennel-ls/archive/0.2.1.tar.gz"
  sha256 "564c9db4565decad5495e6112e025baeeb41000b03b82f237854e485f814f74b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07813eac3528489a90fd5ac7c0d3e56210f6783021a4e9abb51b069edf456515"
  end

  depends_on "pandoc" => :build
  depends_on "lua"

  def install
    # upstream has bump the version to 0.2.2-dev, https://git.sr.ht/~xerool/fennel-ls/commit/6826c7584d35660aac0fc52f3db7a13c52542f3b
    # upstream bug report, https://todo.sr.ht/~xerool/fennel-ls/87
    inreplace "src/fennel-ls/utils.fnl", "0.2.0", version.to_s

    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fennel-ls --version")

    (testpath/"test.fnl").write <<~FENNEL
      { foo }
    FENNEL

    expected = "test.fnl:1:6: error: expected even number of values in table literal"
    assert_match expected, shell_output("#{bin}/fennel-ls --lint test.fnl 2>&1", 1)
  end
end