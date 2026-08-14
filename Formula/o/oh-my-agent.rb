class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.0.0.tgz"
  sha256 "7ad1d578338afd303c8bffb2dce084274a26bb81a1e9005d1fb6cfa00f4c8f16"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f0b03ae6f536719334b301e158dec8d4724ba5523b66987f4af0fc0a255518dc"
    sha256 cellar: :any, arm64_sequoia: "cba0c4ca18857e7902e36c29e55115ac4c33b3bde60a00f486f175112be4db0f"
    sha256 cellar: :any, arm64_sonoma:  "f5d90dc177235cfc253d61e54801d066625949d2ecd1635ae0a70205dce7c8bc"
    sha256 cellar: :any, sonoma:        "aa20ec6cf8f5d42dc5cabdb0d6c75212b47f64d1c3c537ce08d6b80839040ef5"
    sha256 cellar: :any, arm64_linux:   "33c3c51c350ee22d47c3527bf07921519e0d239e3d7027129d69302cb0fce973"
    sha256 cellar: :any, x86_64_linux:  "cb7d7ce5bcf9a4355c36574ae621d4379d97fff05b90af62de9213d572aa4525"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end