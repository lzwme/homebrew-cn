class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.4.0.tgz"
  sha256 "564ffe54b62b5a0cd7c07dc69d6bc6bd1f4443e9a04256c9a1e0bc4ba9e6b24c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "04b9f331aeecaeabf8f020c30f761b5590852079b55044432b783ac2568a2837"
    sha256 cellar: :any,                 arm64_sequoia: "a858c7aef2d71a4db630f8cb491d20f70b23fb3c0012daf8bc93f6a6674da730"
    sha256 cellar: :any,                 arm64_sonoma:  "a858c7aef2d71a4db630f8cb491d20f70b23fb3c0012daf8bc93f6a6674da730"
    sha256 cellar: :any,                 sonoma:        "a4f4bf0d5fc9868d51e1e65ea6c9a10e78eafc35ab78bc770fde4613fb3a6c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f965d91918dd090e78cd9946784b7074bd9fd50341ff81eaec3bd31344194bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04223816db0be200154326ab586378c9e4b24ac6c0a42ecb495631c694ec3c9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@marp-team/marp-cli/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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
    assert_match '<h1 id="hello-homebrew">Hello, Homebrew!</h1>', content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end