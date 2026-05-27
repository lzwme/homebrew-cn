class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.8.0.tgz"
  sha256 "82bd247aa3077d418a2d78c9838c004f9a5082af82100b0e4c8ea6a9d464e0e1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59cfdb7d8607342fc1d3456902fce0f6ecd7a34e6f8c8b5dc6c2c98d31bd2667"
    sha256 cellar: :any,                 arm64_sequoia: "b2918c7d7478c8895f9fe9b35374c8c399a574051cb46bf3cf994158a7393a98"
    sha256 cellar: :any,                 arm64_sonoma:  "b2918c7d7478c8895f9fe9b35374c8c399a574051cb46bf3cf994158a7393a98"
    sha256 cellar: :any,                 sonoma:        "127d985bd73d054bdd8928f76eb840975cce9c2a7fdcf7c6657f2b9a587c2722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "586c44cfb6499e6ffdba947eca6e68b6d577fc4eb09cbcc9af43a1ee38677d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95ad244b76788e3146bb05ff4cc365a01878bbcd2962bd4a0ffa2449f477a0eb"
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