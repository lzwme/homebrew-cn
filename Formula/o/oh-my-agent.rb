class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.12.0.tgz"
  sha256 "f1c7f99de2acfff0abe3332bd4003557e709aac0f427f5c2b3dc2ccda78275a8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "430748425aac2a8c486da724a0ae754c3dd29bce79997ebf2fd8842aa5be2072"
    sha256 cellar: :any, arm64_sequoia: "8fb4194646bece8a0d194576775323197495438f7b0a5dce41480b02d26e81ac"
    sha256 cellar: :any, arm64_sonoma:  "8fb4194646bece8a0d194576775323197495438f7b0a5dce41480b02d26e81ac"
    sha256 cellar: :any, sonoma:        "35e53033395b8124438ffe4137c85d17776cb3eeb6489e2a7bd032338fbb7103"
    sha256 cellar: :any, arm64_linux:   "a609ec923915621933b2e8434292fd58df1e8491e42d75ce7b7397553e733464"
    sha256 cellar: :any, x86_64_linux:  "a4a0a95758fc674ddd8ca3622dc996382094765290c1bf30a9db90cc27e96cba"
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