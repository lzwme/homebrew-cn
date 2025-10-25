class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.16.1.tgz"
  sha256 "42c9ba0e0b1f2e5fb1f109d0ebfcbe34a84abafb97bcb52265bcd0a4ff4064f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e0b5ab6e9f79b05fb8560a9853d709580bbaf6f5daa95946dd3ec4e19a7df26"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end