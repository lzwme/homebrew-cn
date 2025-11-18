class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.69.tgz"
  sha256 "d20f88e58a3e9cb4c9bd42a8b06d45ccb6ae17bcdd59be841e08d3ab3d68d815"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a5a1dfc3c202cb03052d5e870f32702013a258089b1b6022ad2b1817dbcb90aa"
    sha256                               arm64_sequoia: "a5a1dfc3c202cb03052d5e870f32702013a258089b1b6022ad2b1817dbcb90aa"
    sha256                               arm64_sonoma:  "a5a1dfc3c202cb03052d5e870f32702013a258089b1b6022ad2b1817dbcb90aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c0b6d8a250a1253e8f7ca302b1e254d66a6946b5cf03edc6515c7436d3beab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b044f2c5c67bb070a279047eb9a7d6fb8e6926b6cad391db86c03af305d60ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e016fd386b66d0dbb500b47bc4b0dafeb3444a1b3e113e317783b5b14a28720c"
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