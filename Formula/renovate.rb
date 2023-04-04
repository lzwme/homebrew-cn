require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.31.5.tgz"
  sha256 "3f17b47fdc3a34821335786b92f30719e6acb931585b8b71a05056efdb6d2c07"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "deccfcce7949f9e301acaa3fc579c28988299926ed7c231ef7f6aa314f61d257"
    sha256                               arm64_monterey: "2cddf2b7ac8d884dfca725fc506f1463757de683289cb8651779240d0786c44a"
    sha256                               arm64_big_sur:  "abc9fb7740683e13de4aab93c0200979457dd93755b251acc665968d01ebcf4f"
    sha256 cellar: :any_skip_relocation, ventura:        "c64a416c3270a26462ba284fa45130b10f91e279d0f041b8746ff4b501707c32"
    sha256 cellar: :any_skip_relocation, monterey:       "4b0be73f1f9277e80cfc3d55f0a8607947b56ebf2ca9b8309e7e62df8a3e4d2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "788e64862e7db3b139dfe82b32a2a408c112e8a2686b872c4e8c3570516117b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef9ba1e64c54b1ae5730df75e25de75ef61b9bfb1a06ac0c3775dce7f584044e"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end