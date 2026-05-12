class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.5.0.tgz"
  sha256 "107df5a27dbc9e735e1968d559fa852011ef578127556dac097df8dc87ce09f2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76a6080a793a6c3046e8a73f6a44fa42415b3af85371a49f9de56dbe4b2ae6dc"
    sha256 cellar: :any,                 arm64_sequoia: "338ac08e830e8d9e83d2ccdb5f18f57e3aa40951026071a11a6e7a681361567d"
    sha256 cellar: :any,                 arm64_sonoma:  "338ac08e830e8d9e83d2ccdb5f18f57e3aa40951026071a11a6e7a681361567d"
    sha256 cellar: :any,                 sonoma:        "bfad7955d27548ea57058f5001587e6010ee84b870890e0e7593eb4ea0549058"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf2d339d9af6e5f9882b0350e853f8753fc06d6d5d5393880cf1112d20d05776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50cedbebee00d799ed05cea0a38afb6371e89937a186e7d3697729696a5822eb"
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