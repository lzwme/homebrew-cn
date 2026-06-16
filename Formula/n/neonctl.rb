class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.2.tgz"
  sha256 "ed5a3daabf1a53770a253c1d305f05079aec09ea7a31ebc680d75529d116d496"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47e11efe5e1b0973949f2473a6049fb60ee48aba6966d2f560fe1665bedb16d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e11efe5e1b0973949f2473a6049fb60ee48aba6966d2f560fe1665bedb16d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e11efe5e1b0973949f2473a6049fb60ee48aba6966d2f560fe1665bedb16d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "832bdbb5bdcf261255267c422bf29da256b4729423a3b0bce1236a9a17c081e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68a9eab55531611be720b6725bf59c21cf6f3a5e3e37812bff16b1faa119c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6560ccd9cd7962dc7d39305a682ecd6448696707c57a8eb257b1753fe33c7d47"
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