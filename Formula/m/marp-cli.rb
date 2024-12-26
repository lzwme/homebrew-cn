class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTMLCSS, PDF, PPT and images"
  homepage "https:github.commarp-teammarp-cli"
  url "https:registry.npmjs.org@marp-teammarp-cli-marp-cli-4.0.4.tgz"
  sha256 "b182932754cc67262cf7e711e6781e44fb02b6c02209a0223234a19e2be89d73"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b8fbbf9b041c132cc1d764dce5010e75a46b8972357b4f80a7543408f19ad0b"
    sha256 cellar: :any,                 arm64_sonoma:  "2b8fbbf9b041c132cc1d764dce5010e75a46b8972357b4f80a7543408f19ad0b"
    sha256 cellar: :any,                 arm64_ventura: "2b8fbbf9b041c132cc1d764dce5010e75a46b8972357b4f80a7543408f19ad0b"
    sha256 cellar: :any,                 sonoma:        "c2561083aec90e85af13b96d7ec5e65e059c40df96037986df3a8cd55a844322"
    sha256 cellar: :any,                 ventura:       "c2561083aec90e85af13b96d7ec5e65e059c40df96037986df3a8cd55a844322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c0fa26eac4bc958dd375edda9e696e2babcce34e89e5b4418224d7434bbacb"
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