class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.9.2.tgz"
  sha256 "680ea4a627427ee7c7e1f7ef7dae55deafe9a717cb941ca1eb03228adc8e02c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34690b17434aac6e9badb3a6ab988ffd767e1340d488551d85d4b0b78ec6b29c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34690b17434aac6e9badb3a6ab988ffd767e1340d488551d85d4b0b78ec6b29c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34690b17434aac6e9badb3a6ab988ffd767e1340d488551d85d4b0b78ec6b29c"
    sha256 cellar: :any_skip_relocation, sonoma:        "360d71f2e532a47fc45749eabb98e7b965f5b20f380725b6d9a7e605656ecb23"
    sha256 cellar: :any_skip_relocation, ventura:       "360d71f2e532a47fc45749eabb98e7b965f5b20f380725b6d9a7e605656ecb23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34690b17434aac6e9badb3a6ab988ffd767e1340d488551d85d4b0b78ec6b29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34690b17434aac6e9badb3a6ab988ffd767e1340d488551d85d4b0b78ec6b29c"
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