require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.19.1.tgz"
  sha256 "13cc4c9483194d8c16346d4e445adc3b9359914157aa18432b7531e1d90744e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0ecbabbe7b41ca4b0159457b534baf6632f3d2bbd777d62762a179c5d7333bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0ecbabbe7b41ca4b0159457b534baf6632f3d2bbd777d62762a179c5d7333bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0ecbabbe7b41ca4b0159457b534baf6632f3d2bbd777d62762a179c5d7333bb"
    sha256 cellar: :any_skip_relocation, ventura:        "05199ad2698630681cdc4d6f3e854c08a1db5e5b6a676f53301203bcf9c3c6be"
    sha256 cellar: :any_skip_relocation, monterey:       "05199ad2698630681cdc4d6f3e854c08a1db5e5b6a676f53301203bcf9c3c6be"
    sha256 cellar: :any_skip_relocation, big_sur:        "05199ad2698630681cdc4d6f3e854c08a1db5e5b6a676f53301203bcf9c3c6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ecbabbe7b41ca4b0159457b534baf6632f3d2bbd777d62762a179c5d7333bb"
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