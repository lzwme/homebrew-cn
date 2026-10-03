class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.5.0.tgz"
  sha256 "1e0abe72f8c477706f0c4fd82ff24af1feb8c34867695ddc03766ed5e5f8155f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d67a1d771a5c5fd98e318cb4858c73d0e86bb8d254109c7065b7713d8a6e24bf"
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