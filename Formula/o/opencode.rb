class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.68.tgz"
  sha256 "866c8b3d4e12844e90d2a88f9c4ef97dbd11b25aaab0973fe5523f7deb94485e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9cc54e6c16f5f359bd5f43e6cd954ecaf3eac0404c62a1a15ca2c8c2085fed3d"
    sha256                               arm64_sequoia: "9cc54e6c16f5f359bd5f43e6cd954ecaf3eac0404c62a1a15ca2c8c2085fed3d"
    sha256                               arm64_sonoma:  "9cc54e6c16f5f359bd5f43e6cd954ecaf3eac0404c62a1a15ca2c8c2085fed3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c8d0824d5556310a936ded4f3c27807f7fed264f4703aee5f720998f2ca9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "350daf330a1e4d019bf521a84a70a9564c5c0f3c5991e2ce90c22df6fa91aced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd97fe7928da85d8bb9c3e4503aad01fc23f04d440ae7e9fdf05203f3f9e4cde"
  end

  depends_on "node"

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