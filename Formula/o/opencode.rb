class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.166.tgz"
  sha256 "f0f4e10f0399d26cd2ad07e61d614d4ea0db650d70e7bd0fb25c4875f73ced2b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e5f1c0f257f936154e610bd22cc78ac788290cc27b41ab45950d27a7863decd3"
    sha256                               arm64_sequoia: "e5f1c0f257f936154e610bd22cc78ac788290cc27b41ab45950d27a7863decd3"
    sha256                               arm64_sonoma:  "e5f1c0f257f936154e610bd22cc78ac788290cc27b41ab45950d27a7863decd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade27c60f461b0568d014fda145e16a7e905b84e9ecea13afaad5c1a48456031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6772158bb7951f98c3cfe20ca5dc5cb95dc6580dfb9fa2f1619235cf6a70f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ac0ee80830c82f4820be4fc165937b587f7a7c94c8c1a5c0bc9a59a9418d0d6"
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