class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTMLCSS, PDF, PPT and images"
  homepage "https:github.commarp-teammarp-cli"
  url "https:registry.npmjs.org@marp-teammarp-cli-marp-cli-4.0.3.tgz"
  sha256 "3a13e2bb258dd84b571f852055ecf0a469efafa13386092c20c68f86ec09d702"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14137d16423c3b864243ea7fb014935ec8643be2439bcb2a495e4e365dba3f16"
    sha256 cellar: :any,                 arm64_sonoma:  "14137d16423c3b864243ea7fb014935ec8643be2439bcb2a495e4e365dba3f16"
    sha256 cellar: :any,                 arm64_ventura: "14137d16423c3b864243ea7fb014935ec8643be2439bcb2a495e4e365dba3f16"
    sha256 cellar: :any,                 sonoma:        "5457f17cc6a1eb5b827893c8fd622b9cb13cd1af4077472f873d07ca18e571ce"
    sha256 cellar: :any,                 ventura:       "5457f17cc6a1eb5b827893c8fd622b9cb13cd1af4077472f873d07ca18e571ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afeff9e33380997aa9932b7c82588df8dd77342166f99f0999d7730a45cc1caf"
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