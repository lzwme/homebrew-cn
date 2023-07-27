require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.18.2.tgz"
  sha256 "430b84c29dc13aa868ea6cc96167bdf099ef41ed827b4eee6b0225aa07e42833"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce352fd97a7b3a57ebb0d307a75fc9dd50c611e2755ed2657bcfa184dfa014e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bce352fd97a7b3a57ebb0d307a75fc9dd50c611e2755ed2657bcfa184dfa014e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bce352fd97a7b3a57ebb0d307a75fc9dd50c611e2755ed2657bcfa184dfa014e"
    sha256 cellar: :any_skip_relocation, ventura:        "d9e9933ef76f758a1bf042b9ae62e7a119d478d02dcbe8c872699606d86900b5"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e9933ef76f758a1bf042b9ae62e7a119d478d02dcbe8c872699606d86900b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9e9933ef76f758a1bf042b9ae62e7a119d478d02dcbe8c872699606d86900b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3a3f77f2abb7f17b01eb47e52c832c0ccb8de156d24b47dccf7fe96f94b21f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end