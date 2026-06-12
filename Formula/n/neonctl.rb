class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.24.2.tgz"
  sha256 "e040f1c23814b7a89e397500d3b8d0e3e48106f5d97e2a863daf416574de2d28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a52b8eac69e76c0fd66bc297d413c40cda5d4ddd3ddc89f5d76bf26b6dca279"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a52b8eac69e76c0fd66bc297d413c40cda5d4ddd3ddc89f5d76bf26b6dca279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a52b8eac69e76c0fd66bc297d413c40cda5d4ddd3ddc89f5d76bf26b6dca279"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4cce4af4c34cbbaa4ab524f48b8d4762fb646998edb83606c880679c185f837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12c0b0d31ce9020fdc105124c4f19b2815a0b65a26d3041a3b129dc242e55a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34599ea695900cf72387e17351fefb2164f3f30552055e0a24f61604a9cc2ff2"
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