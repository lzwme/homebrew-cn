class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.10.tgz"
  sha256 "a67b59a80f66d28cc2d1413d939a882e01a2d3e490d03e7234a1450acace0eee"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "c8524949c04bfc2c4e2ed7161f8e7f91f8f6f8a5ee18cfe6126289761648803e"
    sha256                               arm64_sonoma:  "e28a70aff874065df201f392ccd27460838082fdf65b5ec1d0bc1197df92448d"
    sha256                               arm64_ventura: "be999a48d7487b78d87d70fbb8e2e632bdd6ea8b842b7a62b25e798ffb93611e"
    sha256                               sonoma:        "1a8757abdbe941d7720942c4a9eb578ff1a189b8e93615fdabf60038aa3e0c0b"
    sha256                               ventura:       "9d3c37dd11eb550b49dba741d05983d60fa1c57fb9d33ae3875402462567c641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20db9a86076ef337b5974a38ca11fe2ac7afced9649c005d00e939fca93926b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end