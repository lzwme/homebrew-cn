class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.16.3.tgz"
  sha256 "aae3286d3cf1024741e0d3f2267f92eb6e862f9681840e0c11bf4a396301c277"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dee22094b5c5ee8a749c7dd85468bf34e3d2d9e61c9e5b723be7ffd8abcd1ec8"
    sha256 cellar: :any,                 arm64_sequoia: "95445dcdc896141e21edd712de429b97eda93ee4df5e36bc3ab5189481ed64a5"
    sha256 cellar: :any,                 arm64_sonoma:  "95445dcdc896141e21edd712de429b97eda93ee4df5e36bc3ab5189481ed64a5"
    sha256 cellar: :any,                 sonoma:        "22d12b43c3f470375b32bab3288f4be58a8da947703705aa450f2111de34d204"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79846dd41c41093c5ec199abf2ecebbc01dbdb03b09154275f85bf48c0beb63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992b9c47fb9f0958895f285f03a705c9d2bc16a06eee9af356742e3d34125b14"
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