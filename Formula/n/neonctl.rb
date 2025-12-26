class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.19.0.tgz"
  sha256 "eaece0178d2cf73630b22cd579e282afe4ba9596d6b7950affbfc7b60af6ffd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bc83a39b432b5d11a307fb00b5746e9d427b85b71e4c468435d0108d6b73cdb"
    sha256 cellar: :any,                 arm64_sequoia: "16555bc78f48dcea809b745f52ca555f70740aeeb5a5fe8ce2cb70965ef26731"
    sha256 cellar: :any,                 arm64_sonoma:  "16555bc78f48dcea809b745f52ca555f70740aeeb5a5fe8ce2cb70965ef26731"
    sha256 cellar: :any,                 sonoma:        "4a1d10ef67635320b00a65707e063f79d321764ac93df0209890e3f3ffed6255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "944fa4cd669e255e5f94d45cc9a57aec83acc6d99399182e85c4fcb00326b062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5f56c9b568ea9734be750bff7f1fb2aa4af604780ee9d1f4e8745d5fc6c39c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/neonctl/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end