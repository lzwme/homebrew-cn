class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.15.0.tgz"
  sha256 "f65ef26fc668dccc90bdcf64ef76da275ae5deba40c4565f358c69257e76dafe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "794886dfbe1636f61342f167824d23bfe9bbfdb8abbc36ad220133137c78baf3"
    sha256 cellar: :any,                 arm64_sequoia: "c337917d14df52a7b4782e682a648c4ba08ea936ca395e5ff3d1e1e0bfc340e9"
    sha256 cellar: :any,                 arm64_sonoma:  "c337917d14df52a7b4782e682a648c4ba08ea936ca395e5ff3d1e1e0bfc340e9"
    sha256 cellar: :any,                 sonoma:        "932b682ad3a21922da12de3effe07578c10bab97a2319e21916edbcc8929e09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88129d5eba98956ace43b3bf9829ac83730c8fc934fd0a12ec1e3419d366edd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3217f5be8b506e0244164232eedb6f11f729768a35de4cc9a711267af95c57"
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