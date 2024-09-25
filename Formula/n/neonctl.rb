class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.37.0.tgz"
  sha256 "f48ecc08b7b38332e25640856c6f6bbfea0558f70f01b997fce281dd167618be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71c936c37b8f735354572e251b7373188d90e82b2e1df2301d4022216a36a232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71c936c37b8f735354572e251b7373188d90e82b2e1df2301d4022216a36a232"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71c936c37b8f735354572e251b7373188d90e82b2e1df2301d4022216a36a232"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f540a384eea8b42489fe99b2be3c0d9e04155d0e6827b88e7d9ad2e0cce3c6f"
    sha256 cellar: :any_skip_relocation, ventura:       "5f540a384eea8b42489fe99b2be3c0d9e04155d0e6827b88e7d9ad2e0cce3c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c936c37b8f735354572e251b7373188d90e82b2e1df2301d4022216a36a232"
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