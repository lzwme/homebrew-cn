class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.10.2.tgz"
  sha256 "ce4420ea745a05721052b7600a4d4620e21e5f967e2de1fa5636779f70344f40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01d2b25f1bddef44007575c3f420c256a1a95a34aca548c1a47d7df7cc1b26e5"
    sha256 cellar: :any,                 arm64_sequoia: "0bfdae7212201904289e3ced4026daf0be84a9c1ad115019ee442a69514ee9f3"
    sha256 cellar: :any,                 arm64_sonoma:  "0bfdae7212201904289e3ced4026daf0be84a9c1ad115019ee442a69514ee9f3"
    sha256 cellar: :any,                 sonoma:        "5c619659e053e05fe7e31afbdb8c20a5698b5f84f0dc24b809202701461959c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4bab607b2a46105eb0ca32a120dca2dd2c95af59e89021290811c89c84fd8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec0667465a9967ec6a1e58cc98bc0fa7b10199cf88f1ec94d901548051bbe76"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end