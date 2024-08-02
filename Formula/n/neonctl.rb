class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.33.0.tgz"
  sha256 "220e4eb63cd0fe44176d588e6f6e2e0b906f0f373ecc1a8bfb96a1ded89f6861"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14e00ca310d9ce5d9af4655d52f1cd6f2b76d5c4cfb7dd1f4b09890cb9a69c9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e00ca310d9ce5d9af4655d52f1cd6f2b76d5c4cfb7dd1f4b09890cb9a69c9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e00ca310d9ce5d9af4655d52f1cd6f2b76d5c4cfb7dd1f4b09890cb9a69c9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8d10a4b9ed381e27f9e5ae2e43f0a3e37919a1d3c30ee7120f86280253e26cb"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d10a4b9ed381e27f9e5ae2e43f0a3e37919a1d3c30ee7120f86280253e26cb"
    sha256 cellar: :any_skip_relocation, monterey:       "d8d10a4b9ed381e27f9e5ae2e43f0a3e37919a1d3c30ee7120f86280253e26cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46dddaac5189ff40536df188b076cce12133633499cd766a3368ac547bdeb7da"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion", base_name: cmd, shells: [:bash, :zsh])
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end