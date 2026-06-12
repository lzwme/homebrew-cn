class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.17.3.tgz"
  sha256 "8f47295fd813c84b8abf27d4cb95fc31d3cd449df9987351306a767ac357ed3c"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "a106bc0784d067fd30613fda66df1a297549fb143a54e44456ac80c5e9ac88c9"
    sha256                               arm64_sequoia: "a106bc0784d067fd30613fda66df1a297549fb143a54e44456ac80c5e9ac88c9"
    sha256                               arm64_sonoma:  "a106bc0784d067fd30613fda66df1a297549fb143a54e44456ac80c5e9ac88c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "46ebc7d26c47eaa33768e9865d0fa9820f297b266f5bba5d3300ca8fa1d48c4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d33a8d0353b78a13e859a4bfedc581e079e933031c9dfc5127eafe1d9cd678a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4c059cd0b1dbb3e00307445466215d8f94c331b91ccb555af7bcf9ab4be563"
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