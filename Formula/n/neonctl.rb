require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.31.1.tgz"
  sha256 "bdd5ae3fef702612e4ac8be2d4832f4efc0fd09552d700f10e900c24f963dc14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a52457fb32cab3b6e24526e39c9099dcfffb1ea607258dfcba115c452700272"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a52457fb32cab3b6e24526e39c9099dcfffb1ea607258dfcba115c452700272"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a52457fb32cab3b6e24526e39c9099dcfffb1ea607258dfcba115c452700272"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4389cc96495a3ff236f77de750a898b3997940af915a1eda90aa307f2925d54"
    sha256 cellar: :any_skip_relocation, ventura:        "d4389cc96495a3ff236f77de750a898b3997940af915a1eda90aa307f2925d54"
    sha256 cellar: :any_skip_relocation, monterey:       "d4389cc96495a3ff236f77de750a898b3997940af915a1eda90aa307f2925d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d827654581dec19a547bb027ce6a2828585cee61d77f46503be818edea5c59fd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    %w[neonctl neon].each do |cmd|
      generate_completions_from_executable(bin/cmd, "completion")
    end
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed", output)
  end
end