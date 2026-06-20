class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.2.0.tgz"
  sha256 "86b8f0b1bb3c421875cfdc1f90d272d5a294839ec2ae7bf398e2e57231696201"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23226cd338ed58db8d79a561e17f4439fbbccfc530c78e73250d3a2da422c1f7"
    sha256 cellar: :any, arm64_sequoia: "8f2c1579eb2e653d413c6301e254e1fe30c6fbe557574f728f311e1893f0c609"
    sha256 cellar: :any, arm64_sonoma:  "8f2c1579eb2e653d413c6301e254e1fe30c6fbe557574f728f311e1893f0c609"
    sha256 cellar: :any, sonoma:        "51d725f57d8b5335496a69193e1a5bc68ccc1435c0e88916eadf01c11dd4bb63"
    sha256 cellar: :any, arm64_linux:   "228e4a256bf7edb1bbe47506f8e9a9f5ca99ea57becee55424633f7ad84dda25"
    sha256 cellar: :any, x86_64_linux:  "38b0bf57f3b459b324549263a555bbbcd5d37d34b2cb663397b7d4547d1fc908"
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