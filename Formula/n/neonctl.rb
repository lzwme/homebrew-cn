class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.27.0.tgz"
  sha256 "b9f9f5ff5231db28e742da6aa80dc0f4152c0c7373c011d247b8c6112e27493b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1804a338e8ba6953230c3441d58eb085bdc6587793f85d439fd50111e1edef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1804a338e8ba6953230c3441d58eb085bdc6587793f85d439fd50111e1edef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1804a338e8ba6953230c3441d58eb085bdc6587793f85d439fd50111e1edef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3144118642f71d55c2b8fa84e8cf402429098021e14b9ad81a3a1719efd6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1ba84ae21c92acbe58553c0bae3e0d1041e2a85a29b895d1184759089f4109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6556410c8355f29094fb5cea20c0fcb76273f58bcc90c78da7c174c0f3bdd273"
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