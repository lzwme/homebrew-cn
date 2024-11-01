class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-2.4.0.tgz"
  sha256 "79b000d2e84b13b587a28b0a4f913c1dc528fe578b07c9db2530c45cabdc9451"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a70b09c1ff128f315cd0208f2c7c740fb33de7f12bf3a79437416ffd54626c82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70b09c1ff128f315cd0208f2c7c740fb33de7f12bf3a79437416ffd54626c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a70b09c1ff128f315cd0208f2c7c740fb33de7f12bf3a79437416ffd54626c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "94aaaab627dcb23ded11d4b03d8816f71fcb864c0025aed3ed3ce8da2350e263"
    sha256 cellar: :any_skip_relocation, ventura:       "94aaaab627dcb23ded11d4b03d8816f71fcb864c0025aed3ed3ce8da2350e263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a70b09c1ff128f315cd0208f2c7c740fb33de7f12bf3a79437416ffd54626c82"
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