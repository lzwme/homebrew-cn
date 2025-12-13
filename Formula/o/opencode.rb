class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.152.tgz"
  sha256 "09843161e4ecb156bdbaa3c8376b2e5ff5a0005e333bd35bb3d6dd2208ad4ba2"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "505cf240eb9878d6a4bd78d1f2eba4f59a9b094d09924b78bc1657636248ccb1"
    sha256                               arm64_sequoia: "505cf240eb9878d6a4bd78d1f2eba4f59a9b094d09924b78bc1657636248ccb1"
    sha256                               arm64_sonoma:  "505cf240eb9878d6a4bd78d1f2eba4f59a9b094d09924b78bc1657636248ccb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d4f3648b096bdcde12ef0ada4f0fc1c64be65d27b4f2c0aa604d5109d5aacf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e27ad5c6fa616b9dc04077c64e516fe68bfe46fe3424894ca9e48933763349cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67ff35f238d309eb0c03c26cd515f0c75f7e5cf64d8fa8ebad991dba82181a4"
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