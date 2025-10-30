class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.16.2.tgz"
  sha256 "e4d58c015e3f1888de2e19fd5b61b64fe50e28196b3db87848dd88e9e9d801ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c786f097745ddf490c3e79b543dfe808ac25d7f165f30129b5e44be306cd630"
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