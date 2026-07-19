class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.21.0.tgz"
  sha256 "cd4d93a946d33978be6df8ba0c5151b88a4ea4600a5a22b01b753370f0b23593"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a651590195d242489649862022207274e3aa89550f0bd36b7011c8c0e94fcafa"
    sha256 cellar: :any, arm64_sequoia: "a651590195d242489649862022207274e3aa89550f0bd36b7011c8c0e94fcafa"
    sha256 cellar: :any, arm64_sonoma:  "a651590195d242489649862022207274e3aa89550f0bd36b7011c8c0e94fcafa"
    sha256 cellar: :any, sonoma:        "902f4a00891c943c927378911c633ca5c839dec3cc5602664b2c6192d7de6229"
    sha256 cellar: :any, arm64_linux:   "cc2909548239e20096e880ca66589c33c2b2be52905d616db26d0b2ffcfd1a5d"
    sha256 cellar: :any, x86_64_linux:  "ff07a0691cbfce0e76adb4b91eb7d0254348e8d7c168c667bf26b2f0130d25aa"
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