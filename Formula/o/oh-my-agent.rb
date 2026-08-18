class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.4.1.tgz"
  sha256 "5b7a8f1806e689ad08e13e9f2192d9cbed975da9d9064ac2d456d258ab231ebe"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0813f49c814edd3cda94ed743cd27792a8e096a3d1053a1dfc7c657b94a3a75"
    sha256 cellar: :any, arm64_sequoia: "0f756715270490e18a7922dcaac1b828a7cb7a48a61028f1d4ab5de6c1bbfc38"
    sha256 cellar: :any, arm64_sonoma:  "8471be98af16287879f6b0dbf6cabed8919a6f8ac29e9223f83464e6eae1a574"
    sha256 cellar: :any, sonoma:        "0a9bd85a86a6e6bb392bff2233fa86bd51160dccf11af08c5afac355e021df5d"
    sha256 cellar: :any, arm64_linux:   "d6253d991cb1adaa3c247daa6b47e83910e70f5f7e7a2b3501a88bd555dde908"
    sha256 cellar: :any, x86_64_linux:  "6c25b2d436ad381a8d63a9a38da65296634ad70ea0ecf3148cca1c380cebaa31"
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