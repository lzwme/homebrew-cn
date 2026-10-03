class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.0.7.tgz"
  sha256 "42138f74a8447b51169bbd1c59db06ca7d3c46119936c07093307b3b32f7e7b8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9eb101d10d49becf50d906a024c462fbce5b48d3f8eeba16a7c0dbad37970e01"
    sha256 cellar: :any, arm64_tahoe:       "b952ac99917bc175231d28866be2290bb7b9483b6e721f6ed3e0ef410295fbb1"
    sha256 cellar: :any, arm64_sequoia:     "061929671828d2b7ce920e4ebd4fa21140690e6fcdaa1151fd52fc412e37a1d9"
    sha256 cellar: :any, arm64_linux:       "d452c571267a33dabd89d11fe9302c871c50ec196ee10a1fd542f10e46f08c75"
    sha256 cellar: :any, x86_64_linux:      "7f49ed7555d5c46ec0d103b75fdded525cad7b81578a8b98955ee235b232b76c"
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