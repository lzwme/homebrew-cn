class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.29.2.tgz"
  sha256 "2c368d4fa69d5ced561243eeb5f67947dfb46310aad23c806316eea59e5c6cd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac783259d1e498a3aa6b124153713d4f68b77b023bcb783cc98d0a3aa5f7c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac783259d1e498a3aa6b124153713d4f68b77b023bcb783cc98d0a3aa5f7c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cac783259d1e498a3aa6b124153713d4f68b77b023bcb783cc98d0a3aa5f7c4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b49acb8fb717eb7dabb76bdd91d0ec61b52f33228dc28222f24842048bc5d7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1b65b8542940bebb4a651c18e7d3e05dd814cee2babb709c9d87fa849a6efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55663cf10e522379573524763b5076a9163961bb564f192e88263c24fb973177"
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