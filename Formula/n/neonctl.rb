class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.23.0.tgz"
  sha256 "9dd0e6e7667d93242b7ff37c187c318a3b3f33891fcefe37eb57b3e0ce4a4ca5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa031c1295d3d6e00f1dc2b72c4d92559b740da3ddc9717c8b6e1fc117ac62ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa031c1295d3d6e00f1dc2b72c4d92559b740da3ddc9717c8b6e1fc117ac62ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa031c1295d3d6e00f1dc2b72c4d92559b740da3ddc9717c8b6e1fc117ac62ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "9221c031471a62f2488f94ac9ebe62d91ca177f19bc47ae9687d69df56b282f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cab4d456029b94fc67c4b6721b6dcc8c3909cb5db72ed31ca5169298b00f564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001fe5ad70d98f5cff9c038d1d6c9f59d1c2c8f2e98c61fad343c4edf8a2bdbd"
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