class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.21.2.tgz"
  sha256 "17108ccf8f7183674115a4c5a023c1cff50d137c85654f1d247ac6cc9754e49d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ee7522cab82e8ab848d76148380a2dcfca5626d368b4fa3f0cad66747d4ebe5"
    sha256 cellar: :any,                 arm64_sequoia: "99573b2fc2d3521b6556ac37b3b37bf49bbdfb5853e883a8649b8cf329509703"
    sha256 cellar: :any,                 arm64_sonoma:  "99573b2fc2d3521b6556ac37b3b37bf49bbdfb5853e883a8649b8cf329509703"
    sha256 cellar: :any,                 sonoma:        "38857ccd4eb1923c264abfbe313759cabcc555e9734b004d7e3378acfc420c5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76572afc292ceda85d2d5de56506e294f101b47cd136081a7db68581ef3cd21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df2978d9559f19755d0f23f0c7381e19c0caef9c1dd86bed59acec0bdb474dae"
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