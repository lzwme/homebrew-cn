class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.16.0.tgz"
  sha256 "74b4de71f9b46cdbac4a9150f68da49e818915270e48ed061203fc3be8c1f442"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "36484f1c7c649f621215fea56fc96eca12fe2d316fc5510d105697e442dc7995"
    sha256                               arm64_sequoia: "36484f1c7c649f621215fea56fc96eca12fe2d316fc5510d105697e442dc7995"
    sha256                               arm64_sonoma:  "36484f1c7c649f621215fea56fc96eca12fe2d316fc5510d105697e442dc7995"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8fdf11f4cf4b53f877ccf018a92bcf47e2b27ecd5412c0d0ee2c1b1c282300f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e9a15d8f46ecbf2ac94b10f903fb7608929b4695ee1d8b844a54fcd41d73a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db67d474a670c9edcea70913ffaf3d5707bb6a19f019b740568f32111ad9839a"
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