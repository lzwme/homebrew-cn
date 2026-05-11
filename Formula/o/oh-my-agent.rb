class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.3.2.tgz"
  sha256 "6815ea23e1167fde9c9b4215a50c519236e0ac4456be74dcf95e04f1d653975a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d2897d1af1dbcfb6fa9450d7d5ac914019122931cceee29a3c69ba192939524"
    sha256 cellar: :any,                 arm64_sequoia: "aec9c5c8cc5899e117f68f4754522d97c9fb02554948841b25311f37d835daa6"
    sha256 cellar: :any,                 arm64_sonoma:  "aec9c5c8cc5899e117f68f4754522d97c9fb02554948841b25311f37d835daa6"
    sha256 cellar: :any,                 sonoma:        "c7c5163eab2d567f4ea3c4cfaabaa06825bff726528a9f56332ef2800e4047c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8cd8f71c0cdabe935c0d9dc256961f0eea3b960deea8ad888a5688d14b26e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "374dda71cffd5e74a08a477d7888fdabdaef94bf0000ec0f8be30fe0782e3130"
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