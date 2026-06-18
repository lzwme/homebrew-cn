class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.8.0.tgz"
  sha256 "9b2878b16d13d518a3e1b9adfcb77c35833ca0c2d92f47cb1568d5a71be06519"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9fe84e9c8de539c65001c5a5268e6026a10869fc103904942b45bbe510c95aa"
    sha256 cellar: :any, arm64_sequoia: "25c21b84edc468402b5da9e6eb0c47ededcc650a77ac7b5d99791cca1a953959"
    sha256 cellar: :any, arm64_sonoma:  "25c21b84edc468402b5da9e6eb0c47ededcc650a77ac7b5d99791cca1a953959"
    sha256 cellar: :any, sonoma:        "5b3cff30990344faf5f8af672b47f9283c974b8d181a11d438f3ba82e9440377"
    sha256 cellar: :any, arm64_linux:   "26e1ad0470b8018ef2c49f4f07a95c3b78ca20fbc3de580b508e3d6a783a4587"
    sha256 cellar: :any, x86_64_linux:  "25084b643569175bee7f236ac29ed40525ef4292fa0546a29ceb62e8d761404e"
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