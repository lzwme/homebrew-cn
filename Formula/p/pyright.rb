require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.322.tgz"
  sha256 "bd0d7aaefad51a5e5737f2dd4f372479c62a9f7911fa72c170f67553560400ba"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9c06adcf79fc198422daf08b3668de89794557b812af4ebb9df02fc50d8b63b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9c06adcf79fc198422daf08b3668de89794557b812af4ebb9df02fc50d8b63b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9c06adcf79fc198422daf08b3668de89794557b812af4ebb9df02fc50d8b63b"
    sha256 cellar: :any_skip_relocation, ventura:        "45f3a068253ba119f727d74cb12cb53bd0a68a1913bfe03f12213bf8812cb572"
    sha256 cellar: :any_skip_relocation, monterey:       "45f3a068253ba119f727d74cb12cb53bd0a68a1913bfe03f12213bf8812cb572"
    sha256 cellar: :any_skip_relocation, big_sur:        "45f3a068253ba119f727d74cb12cb53bd0a68a1913bfe03f12213bf8812cb572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a3f888dd9efb39d4378e3a590d0fbe958ef3fc25b6c724d3f87c28efe8a7af"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end