class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTMLCSS, PDF, PPT and images"
  homepage "https:github.commarp-teammarp-cli"
  url "https:registry.npmjs.org@marp-teammarp-cli-marp-cli-4.1.0.tgz"
  sha256 "4140cc623f9ed6de896115379f80f3d893dd4a2366018cf519a15866722b5833"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be38252689afe4f662bc96460899e8a31df76523662167c087652f053d4d2d4b"
    sha256 cellar: :any,                 arm64_sonoma:  "be38252689afe4f662bc96460899e8a31df76523662167c087652f053d4d2d4b"
    sha256 cellar: :any,                 arm64_ventura: "be38252689afe4f662bc96460899e8a31df76523662167c087652f053d4d2d4b"
    sha256 cellar: :any,                 sonoma:        "7f9d56f3be65b779e2e1867f9da7f6cb20fb9b54c3225bf463ab1102c3590500"
    sha256 cellar: :any,                 ventura:       "7f9d56f3be65b779e2e1867f9da7f6cb20fb9b54c3225bf463ab1102c3590500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65731ba5aad064c06c58c700d8b4ca3503fc7fc6ea90bc02ea984612a1a49bc0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modules@marp-teammarp-clinode_modules"
    node_modules.glob("{bare-fs,bare-os}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath"deck.md").write <<~MARKDOWN
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    MARKDOWN

    system bin"marp", testpath"deck.md", "-o", testpath"deck.html"
    assert_predicate testpath"deck.html", :exist?
    content = (testpath"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!<h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end