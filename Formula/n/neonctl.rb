class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.24.0.tgz"
  sha256 "a8c7fa27f7f580042be4395f42df058779c23783a25d0fe0bf3cec82fa44a181"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0c43ee5f219eb0328d71efced76138a9e7a5fdd7a62b196458b3f99be6b5e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c43ee5f219eb0328d71efced76138a9e7a5fdd7a62b196458b3f99be6b5e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0c43ee5f219eb0328d71efced76138a9e7a5fdd7a62b196458b3f99be6b5e60"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a2a52ce4161a8b3d741bc02b7452120acf0873cdca87b01b9c60c143a2416d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247e0b481986e6cd923df72b90b5bc504bfb34ee3600da5b2a8d65bd5f95c33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60463bda2a795d459ac5f66472142acf594329356de22897241e5637115bab26"
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