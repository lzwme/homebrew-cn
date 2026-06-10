class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.47.0.tgz"
  sha256 "c061260259f6366c67bdb303f1e0c724bed6c7125d7dc7e0ff1dc54e6bc8e91f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5e4bb5b0ebad98fb2ee6170846ed20c2c657fdedb9a62c8d7469739fd8567ca"
    sha256 cellar: :any, arm64_sequoia: "ed8c0859cdf4b2c29c3f50ca00f63614b093f8b77a17ab1458c9cf8332fc4832"
    sha256 cellar: :any, arm64_sonoma:  "ed8c0859cdf4b2c29c3f50ca00f63614b093f8b77a17ab1458c9cf8332fc4832"
    sha256 cellar: :any, sonoma:        "ab32107f23522cc7d56ea3495d4696f0c5c9a06526018f2aea461c70e5d5ae89"
    sha256 cellar: :any, arm64_linux:   "daa407399367b6a3b27baa9912cee8a5d2dfd6d609b76d79bde4bca4e9b1aa5c"
    sha256 cellar: :any, x86_64_linux:  "e7ac2889a849b6836c854c98e1fb17b26766ccb9dd554998e12cddda69dd1764"
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