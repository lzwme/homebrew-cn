require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.28.0.tgz"
  sha256 "834619af4188008e547a4852de63dcc09241ef2751590ed2d4cdf3e2d9e3dfc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4cd0b17e1de1fc70987d16dcade9a9f080c2e1a9a83ca499c42cc9cb72a5041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4cd0b17e1de1fc70987d16dcade9a9f080c2e1a9a83ca499c42cc9cb72a5041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4cd0b17e1de1fc70987d16dcade9a9f080c2e1a9a83ca499c42cc9cb72a5041"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cd2b547723e14df85d984b2d28a1c50453df47b52a3fc40e7542cf574f0c2ff"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd2b547723e14df85d984b2d28a1c50453df47b52a3fc40e7542cf574f0c2ff"
    sha256 cellar: :any_skip_relocation, monterey:       "3cd2b547723e14df85d984b2d28a1c50453df47b52a3fc40e7542cf574f0c2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4cd0b17e1de1fc70987d16dcade9a9f080c2e1a9a83ca499c42cc9cb72a5041"
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