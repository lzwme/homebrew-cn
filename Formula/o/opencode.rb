class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.7.tgz"
  sha256 "fce00477c705e2cfe9cf9e91cd31b54ac9355a0a83e5c6bd2034f4ffb8aad7e0"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "5e514f293808b2f7c576c60850988842ac6017a0eb3f9f44a1dd00e12b1f38ad"
    sha256                               arm64_sequoia: "5e514f293808b2f7c576c60850988842ac6017a0eb3f9f44a1dd00e12b1f38ad"
    sha256                               arm64_sonoma:  "5e514f293808b2f7c576c60850988842ac6017a0eb3f9f44a1dd00e12b1f38ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd1e3d849075705153b1f042b606bb4e877bbaea9bc9a9afa7f1d0be1518ca8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a27e439367acdb12ce89df0c09738522772be4a68490c0b46fba6541f6f61ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ec6b78f606cc88dd12d604d4a625a0552c287f96b0943978789c8ae117015e"
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