class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-4.2.3.tgz"
  sha256 "e5851716df96b0d5fbe3216e38b1f0ce8f7c6ea0bd1c00e712e77d9da56a2bc8"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e9ceb263b61d6f55746ab7c5ab6f4e12ce5bb749a618b17912e49ae7315e417"
    sha256 cellar: :any,                 arm64_sequoia: "17bc3847ffd84cf69b128b48a2220f0610e4715a45f76d9809bf376156a0083b"
    sha256 cellar: :any,                 arm64_sonoma:  "17bc3847ffd84cf69b128b48a2220f0610e4715a45f76d9809bf376156a0083b"
    sha256 cellar: :any,                 sonoma:        "b62c5e31eff56dae8f99b73947a2d343a32f321797b559d1eac71e6127776b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17b66788e0faf313b438502fd14fa066c6c589073c7c2f4df78b3556b2cc7869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea40b743d6849ed00af718af64ce987ca7564569eb42f6fda93430ca64566db"
  end

  # Remove when Node 25 is fixed upstream: https://github.com/nodejs/node/issues/61971
  # Formula-specific tracking: https://github.com/marp-team/marp-cli/issues/708
  depends_on "node@24"

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
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end