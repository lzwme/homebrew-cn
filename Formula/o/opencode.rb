class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.164.tgz"
  sha256 "92eefe4d35a1a7225d09b6c3d56cdc4e73f2dd83a2b6fe57f3d8ab4f611f670c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "06f72551ca442a94331f6db7b8d53133e327a268febf586238e98e479b1e57be"
    sha256                               arm64_sequoia: "06f72551ca442a94331f6db7b8d53133e327a268febf586238e98e479b1e57be"
    sha256                               arm64_sonoma:  "06f72551ca442a94331f6db7b8d53133e327a268febf586238e98e479b1e57be"
    sha256 cellar: :any_skip_relocation, sonoma:        "852833e479e38673c40c2d8d266ef5b9b7c04dd6796e35a446a301e5a3066f5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb78c971c377d5e4c38588846d75014faa3b92d523b6ccdeae12d69545540841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08fb1ed10668c069d5aca9c16371ecbdc58d93055cd9f3e618df7ed344e680ca"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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