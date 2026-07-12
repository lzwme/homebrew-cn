class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.13.0.tgz"
  sha256 "de63eb139ab39c84bd75e9415ba0f5d7d8cdc72427a69d4a6069f4109d1916d2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a665a5defeee246cf74dc07997ed56ebe5fd893d623745d92aa5d21ec007752e"
    sha256 cellar: :any, arm64_sequoia: "4d0f9c24146906b1d118c9f60487d6e08a2b5ab730c279d02e8e46b5d2e87e8c"
    sha256 cellar: :any, arm64_sonoma:  "4d0f9c24146906b1d118c9f60487d6e08a2b5ab730c279d02e8e46b5d2e87e8c"
    sha256 cellar: :any, sonoma:        "0d45b7e22aaeb3613a9fdbc679ea90f90051c962b97d47b3023e3a15fd8de0b1"
    sha256 cellar: :any, arm64_linux:   "cf079f9d3b108610aecfc2604b891c2e8bbd762c3fefeecb809cb059acb4390c"
    sha256 cellar: :any, x86_64_linux:  "6af1ebcf69a0b469784cdca72927523b52d3e03bdc51871ee611b6be326aa0c5"
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