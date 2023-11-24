require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.24.0.tgz"
  sha256 "dcc844f1e98a25d286a93703ce0243de04fc61ffd911a932e43e8ed22252cca7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7896f41474c790131a10ef9ccb3f01569b624e762515801da2a339d1d2518eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7896f41474c790131a10ef9ccb3f01569b624e762515801da2a339d1d2518eee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7896f41474c790131a10ef9ccb3f01569b624e762515801da2a339d1d2518eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b9f701d258808bfd48d95efce369818be9b349e23f945fb6ae9df2b70608486"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9f701d258808bfd48d95efce369818be9b349e23f945fb6ae9df2b70608486"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9f701d258808bfd48d95efce369818be9b349e23f945fb6ae9df2b70608486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7896f41474c790131a10ef9ccb3f01569b624e762515801da2a339d1d2518eee"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end