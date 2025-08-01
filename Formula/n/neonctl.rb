class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.14.0.tgz"
  sha256 "4aafba77b26328d37b6e1014f4a323769482d3e544c09e92c067dc9eee3650d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "741ab2ee4de2abcae988cf4399b6802ca54e677dddb6bd079df2299fa824cfbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741ab2ee4de2abcae988cf4399b6802ca54e677dddb6bd079df2299fa824cfbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "741ab2ee4de2abcae988cf4399b6802ca54e677dddb6bd079df2299fa824cfbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4107000590c8f438100ac8ef9b59ad31e2dd8e49dedc7b6051aa575778686649"
    sha256 cellar: :any_skip_relocation, ventura:       "4107000590c8f438100ac8ef9b59ad31e2dd8e49dedc7b6051aa575778686649"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "741ab2ee4de2abcae988cf4399b6802ca54e677dddb6bd079df2299fa824cfbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741ab2ee4de2abcae988cf4399b6802ca54e677dddb6bd079df2299fa824cfbf"
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