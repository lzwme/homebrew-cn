class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.3.0.tgz"
  sha256 "6ed46d251e50670c8bc9b2d9b937c8dfd7c9865a4d5c5e2eac00643f9a68d77e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "58a34f7a119994f255e1f7293ee5f0867b5bca0a4bca3d0b9367719456f9311a"
    sha256 cellar: :any,                 arm64_sequoia: "a3370cf8d77c10925eba825a85d615f0a4eb4705b4a57bc75e90acd20db9455a"
    sha256 cellar: :any,                 arm64_sonoma:  "a3370cf8d77c10925eba825a85d615f0a4eb4705b4a57bc75e90acd20db9455a"
    sha256 cellar: :any,                 sonoma:        "d060d8787bac6d50f56c4fa7b8e3e37d73402d4928f87ba91deb734bf136d5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9ba616389ef7b83b83a57a4b8fc51beb334fd1718ed60a2a09ce2b89579847e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7789285ea61a9736d086b91de6ea2679230f2cc570c6c019b05aec206ea19ee9"
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