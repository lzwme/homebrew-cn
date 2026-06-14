class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.1.tgz"
  sha256 "157198fb28b7e324fde69c70768fc655999ada1b7c873554ba1725879fc40a2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92e714189f0862a7bafc49bafa4d630484bbeef5ef124f4f0d0bb1b19f4f25b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e714189f0862a7bafc49bafa4d630484bbeef5ef124f4f0d0bb1b19f4f25b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92e714189f0862a7bafc49bafa4d630484bbeef5ef124f4f0d0bb1b19f4f25b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a61ffe3dbbfc923dcc458cdad007e330b284c6b0cf56ba39721cdf3a5699e564"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2359e1e5d4c3955d4dd06787f9c12042fc214b842379bc53edb5e608e367d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a594a08f54c8099816592849bee5ee5e38b0c900e6ca0a6c70bb18e69016b4e9"
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