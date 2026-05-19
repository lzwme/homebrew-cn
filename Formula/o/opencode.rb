class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.3.tgz"
  sha256 "be282c09f6d4fe2889b2566b48f0507c52151528490c2a67efeccbe57a7fe317"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "155054d8df9a4752489b3d4c10045cb8d97c22a3b91183d2d4ea006ab4d2f966"
    sha256                               arm64_sequoia: "155054d8df9a4752489b3d4c10045cb8d97c22a3b91183d2d4ea006ab4d2f966"
    sha256                               arm64_sonoma:  "155054d8df9a4752489b3d4c10045cb8d97c22a3b91183d2d4ea006ab4d2f966"
    sha256 cellar: :any_skip_relocation, sonoma:        "140771d36cbaf954be8725726260d65c63f13c95f77b3d730ff13379c2eb66bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e90e64984d561617480a06d32bde6474d249547dff9ab3228da03bbadc2f7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e591bcc050370306c0a4a5f4038da7a28d0821aebac7bc185d6111ca0792ba07"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end