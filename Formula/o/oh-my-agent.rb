class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.10.3.tgz"
  sha256 "9f800e7146042eab515bd3bc31e5389144b4e9d0c6f9d5ca231182cd0bbe5b24"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3da039439a471aa7a18dfc077d630cfe8f7230d6651312dc093d30fd10200623"
    sha256 cellar: :any, arm64_sequoia: "24301ac0bdc6804732a3428a0f338edb89538adea4d4997d7686fc9182be9e42"
    sha256 cellar: :any, arm64_sonoma:  "e70028fca966d526c38c51f3604615c5d9f368e4f5965dd79f9c8860e87fbbcf"
    sha256 cellar: :any, sonoma:        "4f426e5b2ba50b7e848a6d7e08da50b928e218632544698952bcdb0e48f7e9c3"
    sha256 cellar: :any, arm64_linux:   "8cd84370cd975f559c421669d981e06c1e4f24df4550d0cd70c28b4bfbecca44"
    sha256 cellar: :any, x86_64_linux:  "ee17c1f15fbd03891598ef2efdff9c678b443fbeccf41ca68c795462ccd18e4d"
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