class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.14.46.tgz"
  sha256 "400687189c5cc4913a4fbaf0cc4670c76f9689bbc07db13835406032180e9e2a"
  license "MIT"

  livecheck do
    throttle 10, days: 1
  end

  bottle do
    sha256                               arm64_tahoe:   "6ca4c3ce73149af6c35ded13fd428f1fb9c855f7e9a6c259f88f72582a407e5d"
    sha256                               arm64_sequoia: "6ca4c3ce73149af6c35ded13fd428f1fb9c855f7e9a6c259f88f72582a407e5d"
    sha256                               arm64_sonoma:  "6ca4c3ce73149af6c35ded13fd428f1fb9c855f7e9a6c259f88f72582a407e5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "01b692357eb300296e6b5af7d5722cb32891a27185e3d2f99d4cc77c250f43ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bcc02782fe84e868ae97f145c89e122b63f24a81c2980681cd4374c69a90ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed1af967ef9bd1a1607e1ecd886e43e627b60c4f654f17079f23765a57b624e"
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