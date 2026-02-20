class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.21.0.tgz"
  sha256 "2f28bf5d8cc5e66667434cf77cd34aef33e66a23d8c1533e341bf33d92d76c0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "896a550d97e927623cf3e0e09b5d0f3da4a2252baea3d2d61e2419c739c66724"
    sha256 cellar: :any,                 arm64_sequoia: "fd1c53e40ff42c5ba5ae4fd66fe739508f0eafbdcc43e4852b768cabb6c8542d"
    sha256 cellar: :any,                 arm64_sonoma:  "fd1c53e40ff42c5ba5ae4fd66fe739508f0eafbdcc43e4852b768cabb6c8542d"
    sha256 cellar: :any,                 sonoma:        "b546feb4627f70f62ad0e658e0fe66c28b26cb8cedbb6040d640ed8b792a66d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39572d7e2842d4b18e93a49ef939286fa8f3d5d19a2837b379468dde173d3576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a77b2d06a732effc63c881a4ef7f917eecd9f9f776d838691887ec1168070b5"
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