class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.26.5.tgz"
  sha256 "add3e59d9fc292dfa97bf2018953dafcca7ecdfb67958d274a9839cc3b108640"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d1056e794c417651c442eda6b4bc597a0f370ecf3bf3b89f6bbe3b01b81a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d1056e794c417651c442eda6b4bc597a0f370ecf3bf3b89f6bbe3b01b81a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3d1056e794c417651c442eda6b4bc597a0f370ecf3bf3b89f6bbe3b01b81a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "78aae93a6de1a86ea68e1824c1d1bbcadcdfce55ddff158c8cbe051c3464c9da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb762922b02b7874743d79db776b1b73b990ebcf700606a504096a3155787089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a918148fcd777ea477075ebf143b9d66a47d8cd4b371bcd914c73fe120d8dd8"
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