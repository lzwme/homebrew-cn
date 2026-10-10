class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-16.0.1.tgz"
  sha256 "6e4157120509b28a087c14e88061d41968e45bdd63d75bf7d54cb1823b1144c9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa0b896eda31abb170318fa4b1d825cab0e82d1b6feba9c1c24ae676c883e352"
    sha256 cellar: :any, arm64_tahoe:       "fb1686194f47f062571ebf392ccb0832bc29e4259b95716ba441437a81211177"
    sha256 cellar: :any, arm64_sequoia:     "fcc8786ab0b4e508ffe9ff7ac8b4af8f870a6fc16cf1b7b09359340bce45e3a3"
    sha256 cellar: :any, arm64_linux:       "c3532f2e5e27c49e785f312dfefe4e8bc2d986c3ec1f923dce194e788645dfdf"
    sha256 cellar: :any, x86_64_linux:      "c82a59b9616b569f6c415fcb6233d96831e656eeee95fb9e80d8f38c0ea96391"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end