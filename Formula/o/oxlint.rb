class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.33.0.tgz"
  sha256 "4fe2de8d7909a993b42de6d2f428f89561f5f65c6733a9640372b467a07defa1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d34e90b31363d093559d463705852d5fbc0e808fb957f985c07c0a8ec8de4a33"
    sha256 cellar: :any,                 arm64_sequoia: "4aab854b5831f4d55d28f23f8b0bbcd76bd4494570cac06d5cbc5f508a2ded1f"
    sha256 cellar: :any,                 arm64_sonoma:  "4aab854b5831f4d55d28f23f8b0bbcd76bd4494570cac06d5cbc5f508a2ded1f"
    sha256 cellar: :any,                 sonoma:        "2dfc397577b956beced29a75e888d3ebb8e934d60ff85495f63f60f190904219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba7b57bbc27a5c98a4acb2ff19fa583d3b236ef09127afa17f86c719c9a1ac3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee72dd8fc7b9dca7b953d6fb300a89bfcc7ff867ff00a4aedbccbd97b11494a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end