class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.18.0.tgz"
  sha256 "cc6168baee3e3268776d9d8bf267cb58d3c4ace392a72d2aec59c5d9e083178c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ae1307c01810a2de7f242de848368463db1fbc050c856298cda0841b44d115b"
    sha256 cellar: :any,                 arm64_sequoia: "79c6182904ab499d7b6d6e02ed9776423803bdac07ed407d77d3d3adb94c1cb4"
    sha256 cellar: :any,                 arm64_sonoma:  "79c6182904ab499d7b6d6e02ed9776423803bdac07ed407d77d3d3adb94c1cb4"
    sha256 cellar: :any,                 sonoma:        "14222b3902a811622803a4d10c6da28a74910e4739caff315289091a322b5bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc2eac77f1c42867a83ea6896b701850bd76aae00c0cddd9d91d223acadbc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9be91de883711216e9a90a3c2c8309c8a9bf83782a33c795dfbf9845b413cc1"
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