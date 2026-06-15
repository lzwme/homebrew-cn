class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.17.5.tgz"
  sha256 "05165ae40c9b222db275c8482300c948e881a6767aed2e67056223f43069f99c"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "8584acb177d435cb2b6512bae0a50b1ff8b80192a00060640e2359c1a56c1319"
    sha256                               arm64_sequoia: "8584acb177d435cb2b6512bae0a50b1ff8b80192a00060640e2359c1a56c1319"
    sha256                               arm64_sonoma:  "8584acb177d435cb2b6512bae0a50b1ff8b80192a00060640e2359c1a56c1319"
    sha256 cellar: :any_skip_relocation, sonoma:        "15fa965364bdb3b5ac096d9d403c25d8129beeb5155794bf543319b021523eaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f49604cb707129c71ef2e1d815a9bf070affe8e0d3a76a17264c6faf5f1db91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee06c04a874b0b8c2f70bc6ffcd5ff8c37f8f53c625d1ba40bb548a8ea0acc2"
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