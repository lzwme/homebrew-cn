class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.15.5.tgz"
  sha256 "a277fd68112e5392ea8630a40ba0694327310984d9909929bd7aa0de587ff55d"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "fbd7c676f8816eeaec15946fc175b26cb45911229966132be47e4b6794df7b85"
    sha256                               arm64_sequoia: "fbd7c676f8816eeaec15946fc175b26cb45911229966132be47e4b6794df7b85"
    sha256                               arm64_sonoma:  "fbd7c676f8816eeaec15946fc175b26cb45911229966132be47e4b6794df7b85"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b705f6a323e897eca8d024a7997c2f92778ccc966b8573638ead87f017f714b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5335a24ae530bb05fabced9ca4454fcf8392a6e6ec0ae2edb4a0c39a7e3a57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b85e9d136ab5a51cfd1ef27fe5137c801fe8b04323cdc1acccaf27b6ee2aa3f8"
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