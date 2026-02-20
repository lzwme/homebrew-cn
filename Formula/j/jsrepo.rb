class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.5.0.tgz"
  sha256 "b5472ac278363c831bbbfd41d9a83f2e881bef887fec738e1dcd2e0bb377baab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5daa792bb35f9de0784539ca27ece47e9b2d097bb3f5672c13bc18bce5bc8321"
    sha256 cellar: :any,                 arm64_sequoia: "e30fd10c414bc157ce4b8489b0d5da9eb6338db46a901ea712042b72cbfe046b"
    sha256 cellar: :any,                 arm64_sonoma:  "e30fd10c414bc157ce4b8489b0d5da9eb6338db46a901ea712042b72cbfe046b"
    sha256 cellar: :any,                 sonoma:        "6e5bb07435cd276d92902d518f9cb25ae5dc6c7f26c83e24246a489afa7ba349"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d82f5a8fede63574e6300e32ef1b13fdf05af184dd326424a6c09f9e07e758f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0867bbeb938c75016017cb7e7935f60ea0af98b49f417e036a923f63bd53495c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end