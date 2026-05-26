class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.7.0.tgz"
  sha256 "34ae265e48171ff43bbd6fa066ae9e5f879cf88cdf15595d0c24c432d21a163c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8304bf25fdc041f0e9039c296c7839d99f79977834036f12894e5bee88aaa8a7"
    sha256 cellar: :any,                 arm64_sequoia: "ef170838da908f836a9c09ab150a9867fc1cc018f4a0025a20239131ac83ccea"
    sha256 cellar: :any,                 arm64_sonoma:  "ef170838da908f836a9c09ab150a9867fc1cc018f4a0025a20239131ac83ccea"
    sha256 cellar: :any,                 sonoma:        "3a8ac07ebc70bcd2916376b1375a8ed3c7aed2278b5e4d1cab26621f0a17a563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f73b02521d8d4a9423f7d73fa349c0a4ce9a33f8b09e17d18eef467085e503b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0cf0ebd995cbb0e49557c6d9ea71468049f3cef505dc5f4112b01628fa82f5"
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