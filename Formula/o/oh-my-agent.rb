class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.9.2.tgz"
  sha256 "db8eeca19d1913b93b1baf9cc563f05160290820ce37de739741be678c8173c4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "06bc92f0b400537e75d714ab4d2b0e244d08e37db61048ef336e69cf9dec6e32"
    sha256 cellar: :any, arm64_sequoia: "5039d3a061817a1a7674419a04d1c89c8183af5a1b6032b0dee6b9475b3f9d50"
    sha256 cellar: :any, arm64_sonoma:  "26270f83ee626dd91bb5a66499eeb7166212c286d925324bc96788c472e06350"
    sha256 cellar: :any, sonoma:        "abf0c967afebf7353e07c38addc7b5872d998dc1dc7b7f4f1ca2d8561bd3ed93"
    sha256 cellar: :any, arm64_linux:   "baf63edfcf01826f2eeaa5fca8ceed4d49a954d516b4fb319a582f3006ddd63c"
    sha256 cellar: :any, x86_64_linux:  "ded03fb49c902242b54f33f1939110a4996537417b79608e8116ec7db59f09d9"
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