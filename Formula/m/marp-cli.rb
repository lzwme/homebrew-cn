class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.2.1.tgz"
  sha256 "8500d57e22c6f14a8115ac0ddfa7770da2586339143aa58207c5bb9cca42491d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb02b1eee7c859d2f886c77ec032a0034cc1a0388499b9f9df6a9ee9b7a3485d"
    sha256 cellar: :any,                 arm64_sonoma:  "eb02b1eee7c859d2f886c77ec032a0034cc1a0388499b9f9df6a9ee9b7a3485d"
    sha256 cellar: :any,                 arm64_ventura: "eb02b1eee7c859d2f886c77ec032a0034cc1a0388499b9f9df6a9ee9b7a3485d"
    sha256 cellar: :any,                 sonoma:        "29577c02fe6aab203412d3ca97083f404ae154d3d221d247c1b281b214ecc46c"
    sha256 cellar: :any,                 ventura:       "29577c02fe6aab203412d3ca97083f404ae154d3d221d247c1b281b214ecc46c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03f43ec8aee6f435f6374a62b17275a25bf5f695110ae7db629934ae9cef5fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d738921c655ad323f15a5981eab6f796d40d8b87563a012af71d60bf2adf62f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"deck.md").write <<~MARKDOWN
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    MARKDOWN

    system bin/"marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_path_exists testpath/"deck.html"
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end