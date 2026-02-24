class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.6.0.tgz"
  sha256 "373a4e41c78de6f36d949c0a07cee09fe183e9f6eb4931a9a4de859042f077f1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ed8bb11a81c73f5335a0c18747582088ea59f29f659549fc44e098879afef4d"
    sha256 cellar: :any,                 arm64_sequoia: "5cea94b35447231f234a00683be22ce163c5a98b59c87cac43703aa85a064bee"
    sha256 cellar: :any,                 arm64_sonoma:  "5cea94b35447231f234a00683be22ce163c5a98b59c87cac43703aa85a064bee"
    sha256 cellar: :any,                 sonoma:        "4439c0dd79f6752614deb6c868c520190625724ce237f0584a76745d08de737e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97ec59420287ac67ef75a500c62d102562928ceae479169729cf61627f5e5989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b33492fc79c2c367ac8eb22c5cefae89f3b7e3aede2c52b49b5bcccbfb81d63b"
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