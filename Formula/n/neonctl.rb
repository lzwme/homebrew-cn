require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.26.1.tgz"
  sha256 "617ee9c0b4a170a57fd712a3c053b98a6cc821b58a93c56c3e48480cd171b557"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "860e77716cb8fc23322ef122c19eecbd4a81b1f9e69fe9f2f53784261112877c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "860e77716cb8fc23322ef122c19eecbd4a81b1f9e69fe9f2f53784261112877c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860e77716cb8fc23322ef122c19eecbd4a81b1f9e69fe9f2f53784261112877c"
    sha256 cellar: :any_skip_relocation, sonoma:         "aabdce32f7a14ef466100f8f31cf9f86aeee7c758151cbe57830c2abe40a4859"
    sha256 cellar: :any_skip_relocation, ventura:        "aabdce32f7a14ef466100f8f31cf9f86aeee7c758151cbe57830c2abe40a4859"
    sha256 cellar: :any_skip_relocation, monterey:       "aabdce32f7a14ef466100f8f31cf9f86aeee7c758151cbe57830c2abe40a4859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "860e77716cb8fc23322ef122c19eecbd4a81b1f9e69fe9f2f53784261112877c"
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