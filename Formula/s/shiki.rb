class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-3.23.0.tgz"
  sha256 "8f237bba062ebb2052fa8c33b53a696cd295b5f3ff67d524f631dda50b66d13a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb36a4318b5ffb9eec9df39e24d8bcc6a7a911693f7caf34bd7f90e4e1e8f2ef"
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