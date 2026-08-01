class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.3.0.tgz"
  sha256 "fd843092789de689cb8eaf798f0b61319c93f39c8508ba18f094e5c3d5b8e1bb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "24724fd6fa778f38497cc8a3d6151281a8e3dea72df3df651124cb6656919747"
    sha256 cellar: :any, arm64_sequoia: "5f4f51504588c291e7dc677b18296e23af0dcde1131a0b38ae0180d32850b7a9"
    sha256 cellar: :any, arm64_sonoma:  "3c2af410bcbcfc6c24259a584a1f736a285fc0a292c7abc496a32878fd658b33"
    sha256 cellar: :any, sonoma:        "ed096efc20e3faec60840f3d68c615cd8ce6da8bf40e52e202548372116c48c1"
    sha256 cellar: :any, arm64_linux:   "fc21f12655edfa8cfd9f6b3f02b830376816b5d8f15d71b48f3ae88ad1d8513a"
    sha256 cellar: :any, x86_64_linux:  "2587b07f8e656adec83bded7aa575c7fa849c7b841b0e172e5b94db07daeee43"
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