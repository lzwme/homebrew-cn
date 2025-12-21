class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.180.tgz"
  sha256 "6a2d1b16f85a5b71cd99a2101070c874794d6c1349b1e7f7614cee466bf17e33"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f890a785940196e1801351472b3e29c2854f11dbaa817b21a021356e29ac0150"
    sha256                               arm64_sequoia: "f890a785940196e1801351472b3e29c2854f11dbaa817b21a021356e29ac0150"
    sha256                               arm64_sonoma:  "f890a785940196e1801351472b3e29c2854f11dbaa817b21a021356e29ac0150"
    sha256 cellar: :any_skip_relocation, sonoma:        "28852a9fb865068587077eb598e675e258619f15d96d533cb7412af90314f9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ab64b819441fc1f878ea80066843d10069ce136e0d49b837323bacabb53879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f4841e852d1f1e4fbdda2de75d74bfb3ccbe319dcc03e8d3a835ddf36f33ab"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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