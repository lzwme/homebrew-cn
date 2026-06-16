class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.4.0.tgz"
  sha256 "1e57116baf30d64ef1444ab23df9ae0bd2f4066adc85d885c237b48876c89a16"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48171e7f0420b05657ed65599c69f8cfb069718ab21f31def138e6dd14093b2a"
    sha256 cellar: :any, arm64_sequoia: "0cc16e3f6b45b5944c62286c2ed18a4cec58e134474981308540a7b3c5dc4e70"
    sha256 cellar: :any, arm64_sonoma:  "0cc16e3f6b45b5944c62286c2ed18a4cec58e134474981308540a7b3c5dc4e70"
    sha256 cellar: :any, sonoma:        "3cbce8a1ed805c3f11c89833849ef15e4b7dde7fd21c7369df0a68d0d76bb7f5"
    sha256 cellar: :any, arm64_linux:   "cc8baf754ac2730c60fba415e3c25630d862c94a0302be6e5d2488af368d94a7"
    sha256 cellar: :any, x86_64_linux:  "38a4963ec092f85c500e5259d6f5f3a42e78ca362a09ba73d5b8e3cd2638aca9"
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