require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-3.1.0.tgz"
  sha256 "b6bd44ccd6cae0ce9f17a748f57908ad66d27e061c5dc8b1e904880b25551412"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06b6f829df44233aa39d014e6002d6c2f5fc2e23878b401c68c8fecac6626520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06b6f829df44233aa39d014e6002d6c2f5fc2e23878b401c68c8fecac6626520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06b6f829df44233aa39d014e6002d6c2f5fc2e23878b401c68c8fecac6626520"
    sha256 cellar: :any_skip_relocation, ventura:        "4b9d6c2374612bf8a3101849655478f57bd55ee52f89ea9c337e315708f3ddf2"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9d6c2374612bf8a3101849655478f57bd55ee52f89ea9c337e315708f3ddf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b9d6c2374612bf8a3101849655478f57bd55ee52f89ea9c337e315708f3ddf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "275efc8ae6bd63ec3a658e088d9d6323cc4cb06d3279967779fc92241efd2a78"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"deck.md").write <<~EOS
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    EOS

    system bin/"marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end