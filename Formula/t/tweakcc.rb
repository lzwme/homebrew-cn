class Tweakcc < Formula
  desc "Customize your Claude Code themes, thinking verbs, and more"
  homepage "https://github.com/Piebald-AI/tweakcc"
  url "https://registry.npmjs.org/tweakcc/-/tweakcc-2.0.1.tgz"
  sha256 "cd150013f5a84ffacf0ca28c159b6a3aca633e2bf0e4bd09a3e4e9a1fc3de5ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af80b24591c7b88ba5870e9216f9d37b8eeeccf25bffce9edd7b171a3e6f3069"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af80b24591c7b88ba5870e9216f9d37b8eeeccf25bffce9edd7b171a3e6f3069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af80b24591c7b88ba5870e9216f9d37b8eeeccf25bffce9edd7b171a3e6f3069"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d3ba3355f21ebc4a6c0c29112311d2bbd5f4a8cb30799884663ff74d7525506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3ba3355f21ebc4a6c0c29112311d2bbd5f4a8cb30799884663ff74d7525506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d3ba3355f21ebc4a6c0c29112311d2bbd5f4a8cb30799884663ff74d7525506"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tweakcc --version")

    output = shell_output("#{bin}/tweakcc --apply 2>&1", 1)
    assert_match "Applying saved customizations to Claude Code", output
  end
end