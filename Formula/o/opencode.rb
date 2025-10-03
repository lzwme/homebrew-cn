class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.14.0.tgz"
  sha256 "915a8f8c3482e79f9c7a62845da5cbbf7ce751359c62f337bd9cb8b8d3864b26"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "57bc1956a4a9188b4e6a1b645f21535873fc5b7ba5fbe77625f66c07d9e06ec1"
    sha256                               arm64_sequoia: "57bc1956a4a9188b4e6a1b645f21535873fc5b7ba5fbe77625f66c07d9e06ec1"
    sha256                               arm64_sonoma:  "57bc1956a4a9188b4e6a1b645f21535873fc5b7ba5fbe77625f66c07d9e06ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "63bf30347763b3f0abcd810c3aec1f6e6008903fcc30aa738211f09f0f629c96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "146c5d32b2894e7157cf721996ae896ac8856e100fa7922b8535ffc2810c5a05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc83fb224ba45caee8cade0b1c77d21848a32a772c54ddea2412346f597a253"
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