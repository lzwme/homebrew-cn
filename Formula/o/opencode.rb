class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.220.tgz"
  sha256 "c4bf1790626001477af0c1feca476c53091e351bccfa0585c1e8c47c0bd57b70"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "9b73883da81dbdb07c59ae54acb6447b3780d1bbd8e2dc1fdd0604ee398ba093"
    sha256                               arm64_sequoia: "9b73883da81dbdb07c59ae54acb6447b3780d1bbd8e2dc1fdd0604ee398ba093"
    sha256                               arm64_sonoma:  "9b73883da81dbdb07c59ae54acb6447b3780d1bbd8e2dc1fdd0604ee398ba093"
    sha256 cellar: :any_skip_relocation, sonoma:        "57c5ed35393c033db9180793affc2a89ab2325a892d4bcb750d6e6e4acf77d6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5829a5d3479830dbba3e1375b7efec6e9c657dffe87fb02dd8272fc469f4b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d525cd1368cddddc44c68d1af96a2d71b9aef09395e0f562c78a3d18f8331b1f"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
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