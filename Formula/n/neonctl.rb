class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.17.1.tgz"
  sha256 "991845e248e7b113e3b6209391f89ac21a6c2cc7f0f6c28707a93f6d5b4efcc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c3d410752a8acf77b6f2e7fb5f5c6d7d28e7fcaf8f177f92bd29efc5a52474f"
    sha256 cellar: :any,                 arm64_sequoia: "5bfe34f28d7f4e6a4d31c8637de41d8a5fd68b739c887672ea4157c0121a387b"
    sha256 cellar: :any,                 arm64_sonoma:  "5bfe34f28d7f4e6a4d31c8637de41d8a5fd68b739c887672ea4157c0121a387b"
    sha256 cellar: :any,                 sonoma:        "5a21913a4e8a7ae86e4c3c56fc5b4efa3a8eb73f11b71f493e955344327d12bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8823b176f5e059cf590a66b2e8e1bacbb2826f45e663c2eb5665b5de54375073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "382422384222066387edfde37a8a967dfda734b34acbff265394dd88732eca15"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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