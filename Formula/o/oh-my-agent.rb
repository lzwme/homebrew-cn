class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.40.0.tgz"
  sha256 "83fb3086f2c83250fbf357c0a20f790d2616dbf9bda307a34c283fd55a23aa98"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31446e6ac87cbed3b4511375e12b4a34f5e94850c453d055ca3bc1d1d399da48"
    sha256 cellar: :any, arm64_sequoia: "9cef90b486ac56478a4bf4736c370c50d1ad659cd12dd4f49357aeeae0f0be3e"
    sha256 cellar: :any, arm64_sonoma:  "9cef90b486ac56478a4bf4736c370c50d1ad659cd12dd4f49357aeeae0f0be3e"
    sha256 cellar: :any, sonoma:        "34d28961d9e772c5d66dfae76c97cd27c8e1c98ee3e5f6c095bb73baacff3711"
    sha256 cellar: :any, arm64_linux:   "976ef93919ad882eae9a9c55da1f82d162b12d7c8a867d67a5758b1ac4b9868b"
    sha256 cellar: :any, x86_64_linux:  "474d43d769ab7e5a360a384f6ba253d85f899c0202cfe0d1503c92695632877c"
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