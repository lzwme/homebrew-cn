class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.1.0.tgz"
  sha256 "15def28737707f9ec227a79734e901631b5b3099c4950db234ae1a9ceef0257f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68fc16328c5514bfd180ccd8e8b1a4b8f0d1ecde1e6881eae803d6f41f1d8311"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end