class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.0.0.tgz"
  sha256 "4550d1d970792a68391b36481085a5a444f3a466101de58d656829fe6c34ad52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e0e82322496bcce948883ddb3b6ed2f4ce5018d5bdfa5b3c5ccbaa546e377ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiki --version")

    (testpath/"test.txt").write <<~TXT
      Hello, world!
    TXT

    assert_match "Hello, world!", shell_output("#{bin}/shiki #{testpath}/test.txt")
  end
end