class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.6.tgz"
  sha256 "871c09d8f1342e843f269c21a767703cf7654decfa21455afe3cd78d5ee4c50d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5665aa1f0226a941af1ee552cea9510bdb57b161b05683be1d5bca9549555c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5665aa1f0226a941af1ee552cea9510bdb57b161b05683be1d5bca9549555c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5665aa1f0226a941af1ee552cea9510bdb57b161b05683be1d5bca9549555c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd28c11c68a3a6b177101f364a925d0b2f8147c412243089b5b06e3d824fb4ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e34e0f1afeb2b75ed0bce96b643ad63ff78889ddd32cc50f435eac467f30a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9394d97bf66a550b86597579622beac68f92c7b5cfc38cf4ccd38ed96d51e3"
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