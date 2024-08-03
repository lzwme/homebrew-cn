class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.34.0.tgz"
  sha256 "cbdc1c4c5267795a1e4c9de97b4e3b48d14650b5f3c1821b2954a698106ec261"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b89385883849a05c84ea28fe2765715fbe92719afac68e7a504d145ad7c5b91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b89385883849a05c84ea28fe2765715fbe92719afac68e7a504d145ad7c5b91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b89385883849a05c84ea28fe2765715fbe92719afac68e7a504d145ad7c5b91"
    sha256 cellar: :any_skip_relocation, sonoma:         "cac9744e575c6dd5ad89f97f26862402058f2a565103f5d55ff17bf0e221e12f"
    sha256 cellar: :any_skip_relocation, ventura:        "cac9744e575c6dd5ad89f97f26862402058f2a565103f5d55ff17bf0e221e12f"
    sha256 cellar: :any_skip_relocation, monterey:       "cac9744e575c6dd5ad89f97f26862402058f2a565103f5d55ff17bf0e221e12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b89385883849a05c84ea28fe2765715fbe92719afac68e7a504d145ad7c5b91"
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