class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.2.1.tgz"
  sha256 "a0aab754f2c4b174b9281eed7ff9b91345ef21d3a70993c67aeeab393f89a842"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d56499815247bd77fee48e1c42e2e114aab850bf8f74b382a50c8f5ff02c08e"
    sha256 cellar: :any, arm64_sequoia: "676fd3cfaae2eb8ba7ae38a298750618fa6ec2ee5dcd9846820d38ffccd14890"
    sha256 cellar: :any, arm64_sonoma:  "264f949aefef15b276007e884ce033b551add4bc36bd1695e7ab51e326b467a9"
    sha256 cellar: :any, sonoma:        "ffd1952e9a9de5d4a2855444eb77d083e949f01d44247a9994ecc960aa10f0a0"
    sha256 cellar: :any, arm64_linux:   "7d6548e50adf23b20622fa624e27a8fe2baf88ab8f9b128677198d108f63ee0d"
    sha256 cellar: :any, x86_64_linux:  "562e47491d066fbea2a0715ee94c3a1ce6add6d11329c8027b2f4ed519759334"
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