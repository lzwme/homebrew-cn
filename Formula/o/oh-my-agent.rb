class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.8.0.tgz"
  sha256 "2418d1d66f0249404818be67dede28b1a3c8d724e26173f95c35801d3f7c2652"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2782a5c167268ad8e02d081aa78cbfc8626540849e116967a08f0fd306cc7138"
    sha256 cellar: :any, arm64_sequoia: "e7862eb9e120c86d128b2c391cc467e2aac60407b7cf37a3e778c2c46dbf072d"
    sha256 cellar: :any, arm64_sonoma:  "e7862eb9e120c86d128b2c391cc467e2aac60407b7cf37a3e778c2c46dbf072d"
    sha256 cellar: :any, sonoma:        "3fb4609940995aa5c1d7e3b569cf92bca45f03cb7715e9f600283d25b4ef1858"
    sha256 cellar: :any, arm64_linux:   "67c59f9564811e851b8c16dfc0ffafc46e0535fd7b24fb0a5b2414f5a224be70"
    sha256 cellar: :any, x86_64_linux:  "ab5824f6e96dc1613caddc132f76c466db2211e844fbf4e7092e99273b46bbf0"
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