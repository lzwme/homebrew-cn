class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.20.1.tgz"
  sha256 "c13390a1f5a1f1b2c4a14b5f954f6ba0659526abf7b6e442fb979bc689605515"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7b18277ecfd7a8ec84fb0c5d1cc81915ea98b805e0f798f19345e897eeb08f0"
    sha256 cellar: :any,                 arm64_sequoia: "57e651199801c10f5984be88ac2729ae93dbe9b8a4c5cc76f37fb972226adeee"
    sha256 cellar: :any,                 arm64_sonoma:  "57e651199801c10f5984be88ac2729ae93dbe9b8a4c5cc76f37fb972226adeee"
    sha256 cellar: :any,                 sonoma:        "02834ef4223c8b376363a395be1b5b2904135d4641633eae121c24186a8b1d54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65333d2f7c1217761d7fae758ed02c963b5382052b097e2e22ed8c6ec76c3635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b9727025f451eb1c216b74e1432ee44c8aea8911e03cc82037481a47416915"
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