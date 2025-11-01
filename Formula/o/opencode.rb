class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.4.tgz"
  sha256 "dd3abc036940f0439fbe58b0c1a2830b392e57914f45dc756be9265cd0d7c51a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e40e4756b85371b5789d5d4338112ad21c0543e62d68913df4a73dd13c352681"
    sha256                               arm64_sequoia: "e40e4756b85371b5789d5d4338112ad21c0543e62d68913df4a73dd13c352681"
    sha256                               arm64_sonoma:  "e40e4756b85371b5789d5d4338112ad21c0543e62d68913df4a73dd13c352681"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c32be3347d294dbcaff8130b21ea873261710b8f25161636bad18d182a40d3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb0dabba2c152d288e4560f4d9c0be0ac38ba111e6bc0b589afeeb4d36e908f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ebce149433625229c153fa449a2b27cab18e3bd75568dc57761170116b6fec6"
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