class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.0.1.tgz"
  sha256 "32947005eaee1381babc0c2daf55404a97a91cc9590e03387b1f69a505c7c2c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7cd0aecfc49162184d7322b78f49a0ac999e105cf548033fcbcfc37f385e85e"
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