class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.3.10.tgz"
  sha256 "5e266285a1d65e4ccb3bbc8d9e62cec2b0a3b9cec2fd11b5877bbe050064f7db"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "f7e83bb7f048be1e83f41c6dbe23ebebb933ff9b33242b3ae241ac3e0c925ce5"
    sha256                               arm64_sequoia: "f7e83bb7f048be1e83f41c6dbe23ebebb933ff9b33242b3ae241ac3e0c925ce5"
    sha256                               arm64_sonoma:  "f7e83bb7f048be1e83f41c6dbe23ebebb933ff9b33242b3ae241ac3e0c925ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ef378c9621c40973b4277334688c20e2b5790b13ca059e06bd71a45872307a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bea9fdb2f14d5e04d537eb56e3651d975fc128b68e3dddc4efc1814ac0ebbac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b2e8a241fc036be46be8b79539319d69a19d55f591b6ae37bd7ef05729e998"
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