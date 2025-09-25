class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.11.3.tgz"
  sha256 "82f911dcb05754e29cc6502a220ab4e34fe45b9e42fd52bec2f2b115ad2f1883"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8c3867fb8294935004a4c618fbf5bb196101967a30da616f81ec16377b2f527f"
    sha256                               arm64_sequoia: "8c3867fb8294935004a4c618fbf5bb196101967a30da616f81ec16377b2f527f"
    sha256                               arm64_sonoma:  "8c3867fb8294935004a4c618fbf5bb196101967a30da616f81ec16377b2f527f"
    sha256 cellar: :any_skip_relocation, sonoma:        "79de42b858dd8a6cf274241f95226e4ab34ecd50723af3a6386f4af658682e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "059e975477a0286bcb905302aa07a207b22116ad60bac7fe05cb316e0ba17540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ed325ec813968997ca9d0fc695685674ab7232b0b8164b30d4b8f95ccdef1a2"
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