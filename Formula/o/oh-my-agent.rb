class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.18.0.tgz"
  sha256 "0fa9e2b7941f5bb762e3b644aea2cc773b6fd125b1e0b09daaf2c0ff384a12bf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c6d990389d6bd4d5c931294fd8d2388c2bf9a2bf80c569b783cedee1d845a30"
    sha256 cellar: :any, arm64_sequoia: "4ed483aea6c83da58aab0833beb0fe4291378412df32fc75d86aac35b13096cc"
    sha256 cellar: :any, arm64_sonoma:  "4ed483aea6c83da58aab0833beb0fe4291378412df32fc75d86aac35b13096cc"
    sha256 cellar: :any, sonoma:        "48282d5530976a70340b59081b1a63d7bf54d3a6c00ceac4792458b4e84f8608"
    sha256 cellar: :any, arm64_linux:   "a58dfec3b82f3c781b87a4a66cbc9e70394c773b337655ec7c4453ade435578d"
    sha256 cellar: :any, x86_64_linux:  "c05c18c970dc45d35735295ab7ba7d2158efd6c8d0cb1e54640c8de75ec64b25"
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