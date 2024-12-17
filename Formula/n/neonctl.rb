class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.4.1.tgz"
  sha256 "8611d473eacdfdcafe630581fb733eda341b308d60e661f846b05185b1cb9f94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3c7b9d3c69e96d5c29f7bd594349af1dbf8208120145c713a9c5c1ea1acaf66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3c7b9d3c69e96d5c29f7bd594349af1dbf8208120145c713a9c5c1ea1acaf66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3c7b9d3c69e96d5c29f7bd594349af1dbf8208120145c713a9c5c1ea1acaf66"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f311eec252c4cbddf96ecd5bb11d2483578f5b0fbd49d0f2f45de917e7f6076"
    sha256 cellar: :any_skip_relocation, ventura:       "9f311eec252c4cbddf96ecd5bb11d2483578f5b0fbd49d0f2f45de917e7f6076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3c7b9d3c69e96d5c29f7bd594349af1dbf8208120145c713a9c5c1ea1acaf66"
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