class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTMLCSS, PDF, PPT and images"
  homepage "https:github.commarp-teammarp-cli"
  url "https:registry.npmjs.org@marp-teammarp-cli-marp-cli-4.0.2.tgz"
  sha256 "68fc87f159b13e2a4c0910ccb2d7abea08028e6738fa3da709fd1d78c9699f10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "788931577204e4306d5a4e8bab09f4721bc31047c0cfd5642ebde3b4e200484e"
    sha256 cellar: :any,                 arm64_sonoma:  "788931577204e4306d5a4e8bab09f4721bc31047c0cfd5642ebde3b4e200484e"
    sha256 cellar: :any,                 arm64_ventura: "788931577204e4306d5a4e8bab09f4721bc31047c0cfd5642ebde3b4e200484e"
    sha256 cellar: :any,                 sonoma:        "a4a03073eb3ccdcf3fa66d46b148ccbdd6d74f1d114a72f7afe98fbf19e418d4"
    sha256 cellar: :any,                 ventura:       "a4a03073eb3ccdcf3fa66d46b148ccbdd6d74f1d114a72f7afe98fbf19e418d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6efbf23c20809bfdd5c625af00533ae9168d98bb321b2445cd0649540a4064"
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
    (testpath"deck.md").write <<~EOS
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    EOS

    system bin"marp", testpath"deck.md", "-o", testpath"deck.html"
    assert_predicate testpath"deck.html", :exist?
    content = (testpath"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1 id=\"hello-homebrew\">Hello, Homebrew!<h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end