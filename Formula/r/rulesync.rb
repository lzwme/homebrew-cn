class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-21.0.0.tgz"
  sha256 "90b02e68e05e109500feeb00850afc3ffd93272cf94bdeb763d77c3fb5106596"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19890a3cd2de8de654dccfabbe305e3584ccca69ad1b57aff3d450cf5bd92c5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19890a3cd2de8de654dccfabbe305e3584ccca69ad1b57aff3d450cf5bd92c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19890a3cd2de8de654dccfabbe305e3584ccca69ad1b57aff3d450cf5bd92c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca2251f95493b44b700c37fdeae9ab3c8f0bd3c1efe922ad609dacf7a2cc10b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca2251f95493b44b700c37fdeae9ab3c8f0bd3c1efe922ad609dacf7a2cc10b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end