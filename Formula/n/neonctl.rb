class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.16.0.tgz"
  sha256 "400099d8cd12e0e3ff76bf16d31eadde7e408e06969d221b097689ea6fa41144"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "245aabffd2e4c3d02ac947db30cd0c5dbd400bd8fc166961ebe9e76ea1357653"
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