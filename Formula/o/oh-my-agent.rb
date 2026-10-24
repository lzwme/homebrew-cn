class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.12.2.tgz"
  sha256 "90c887a05cbf14487eebca4e6bc52e42cec4e8492b59aa5711792e979868aaa1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cee7f971d655ba6d4bc7b1555520f22a89313131fdaf5e13ea29e0e2cf231f4e"
    sha256 cellar: :any, arm64_tahoe:       "3e98c44380c0a81f019cf727a7694be8ec3228fa4f69d729d9cde6afd89f13a4"
    sha256 cellar: :any, arm64_sequoia:     "e997046059ae17579a3a9b770a9e9cd9405422554d1c7ccd36d382883990e951"
    sha256 cellar: :any, arm64_linux:       "5ad5c5eb96cea1a2516a8fcdfa2700111a1c5464386271d15c18d7e7188305e0"
    sha256 cellar: :any, x86_64_linux:      "199ac93dae7b7c42fe7ba1af213a8afbf8923ad54fdb97d2d2cbb96a71ad3521"
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