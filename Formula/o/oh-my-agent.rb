class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.10.0.tgz"
  sha256 "123417003715344d9c65f138bc2ab41ad81225289d593251cfe213220f9bba5c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e82160345ee4117e44683dc34a106d355f21b369a8fde8e1a612d6c7d64db96e"
    sha256 cellar: :any,                 arm64_sequoia: "3abe4118fa485de1fcef6bcb50ee194180df8dedf8fa9c54c7bde0e15dd2a4b0"
    sha256 cellar: :any,                 arm64_sonoma:  "3abe4118fa485de1fcef6bcb50ee194180df8dedf8fa9c54c7bde0e15dd2a4b0"
    sha256 cellar: :any,                 sonoma:        "df075d2cfd0cc260aa82be75af19c8cfb3cbaa7129bbf6f32434970186b7675a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcad33778b1cf70f915cff1109d7830847d542214a5e033b5272a1f5157d3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c40d57ac0742159da8ea4de5a5312a5ecfbcbde3c1bee0d95a47e3e84f0600"
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