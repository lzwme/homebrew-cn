class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.6.1.tgz"
  sha256 "da16770070d53404558d7f9b9871103e747abc320f7116ef895d8f10e30ceb8e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a8f1372607b2c716f8ed4f237965f9bde35b0b51b51f99346ef80bcd23f075d5"
    sha256 cellar: :any, arm64_sequoia: "07b67811329576042d75e00e6bb26be115bd1c39182d873785ba831a77d7c140"
    sha256 cellar: :any, arm64_sonoma:  "07b67811329576042d75e00e6bb26be115bd1c39182d873785ba831a77d7c140"
    sha256 cellar: :any, sonoma:        "6db08b67f24b0e472f4f498753e2ee13faf629d60150968ec86c0bd7c89961bb"
    sha256 cellar: :any, arm64_linux:   "582b2b9d73b47999b4b85dbb5c8aa690aeb027e990c64e6f0b3a5ac8eee1d019"
    sha256 cellar: :any, x86_64_linux:  "6a810726fc95e693fad08737970bc0f8dc5366d1f8166f34af25fee94a0527ef"
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