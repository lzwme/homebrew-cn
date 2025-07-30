class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.2.2.tgz"
  sha256 "56c9b967d14c11ba63adedeeb0bf7c7bf8dd98ed6340bba56e52e5b0185c052b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca56a34665630d24223bde44ac879378270e6429a564633829842266891248b8"
    sha256 cellar: :any,                 arm64_sonoma:  "ca56a34665630d24223bde44ac879378270e6429a564633829842266891248b8"
    sha256 cellar: :any,                 arm64_ventura: "ca56a34665630d24223bde44ac879378270e6429a564633829842266891248b8"
    sha256 cellar: :any,                 sonoma:        "a67b2fcaf738571317711c7c78db134807ca520c46985423a28027e6d3f4c544"
    sha256 cellar: :any,                 ventura:       "a67b2fcaf738571317711c7c78db134807ca520c46985423a28027e6d3f4c544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1af43f565f94e8418d52e0e33ad06f229d7a3e3a8cf79ccc9158d37aa66e0a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a5751b36f4aaf73285deaef05c67721c27044ebb665dce6d8441a3179dadebb"
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