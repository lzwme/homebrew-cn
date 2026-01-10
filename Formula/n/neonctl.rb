class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.20.0.tgz"
  sha256 "c1813d0b9a324d8ed36aa434bc9938d757a279ab8f3656747412821b1f92dcc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b74cbf2c7081b2633273d3355513a0f33b4e775d52d60c19807b8a30a02915c"
    sha256 cellar: :any,                 arm64_sequoia: "13a1707a16c0962ab51055f96762f68bda37ec2d77c5fa1b0fcccf7eb8c88d80"
    sha256 cellar: :any,                 arm64_sonoma:  "13a1707a16c0962ab51055f96762f68bda37ec2d77c5fa1b0fcccf7eb8c88d80"
    sha256 cellar: :any,                 sonoma:        "817197300d45b25e45cf4374222b18579b42b104d1a2dadff2f45c52384a24d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa391f13ffedfdeb34e0a1cb51cb88ea65035a0cfff10639cc48c37e92a3a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c666005b8a95f70d7d2a79896c93e8fdd00ffff7368c9e1df8ea7ed100d1f2"
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