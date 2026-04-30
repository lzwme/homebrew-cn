class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.14.20.tgz"
  sha256 "843679b137cb587c9b98d7388bca867957d06e01237d9d70a247a99af4fc0716"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "9298d238bb7b01b4709d2833f9ea74797e7254ae36eccf6f9f22e4f54b4c94d7"
    sha256                               arm64_sequoia: "9298d238bb7b01b4709d2833f9ea74797e7254ae36eccf6f9f22e4f54b4c94d7"
    sha256                               arm64_sonoma:  "9298d238bb7b01b4709d2833f9ea74797e7254ae36eccf6f9f22e4f54b4c94d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "170830c2de572ed8723dad64f7fe51fd56d1eef10d896dd704976826c3c617b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96aa82c688429a14be1d0462d0e4e5acd2e6b11bda7a3fdce376ce5c4f344ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6431e78ce42a3cb1a023993381ea79913d9139fb6739684825006c3ec06e38"
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