class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.12.tgz"
  sha256 "04c016a652e642bc6d4b4f41c4d605d8421b0b3dc5d3a698c84c54019c6d906a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "97a4307874d85e13ced6a17581e8a799b138c0216d3c952e03c1ef6179f4cf53"
    sha256                               arm64_sequoia: "97a4307874d85e13ced6a17581e8a799b138c0216d3c952e03c1ef6179f4cf53"
    sha256                               arm64_sonoma:  "97a4307874d85e13ced6a17581e8a799b138c0216d3c952e03c1ef6179f4cf53"
    sha256 cellar: :any_skip_relocation, sonoma:        "bed5498e74053315fe5778a560aaaa3fcec18d66df8bc46f745da77170e80c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a582ba2786e97e9a2fd081b70efc52dd9088357e861eca47ae22ca80998050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6dc76289d5f35faf94251375cbbf27b1c5875f43e4c814f5c23a5048b2f9072"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end