require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.336.0.tgz"
  sha256 "10fc8d8aaf2c346541ee50ff1b16b83657a7a312520389906013cbdc5f8c42a2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256                               arm64_sonoma:   "7cfc5f14f596d5b724e8a2a3a65e736feae2fad7689c9082238db1fed7886a0f"
    sha256                               arm64_ventura:  "3d02145656b2b26ee5f42c89310e0f1b1c29812a41662183f9766c8371f46b88"
    sha256                               arm64_monterey: "89d27820004c500409ab3761b625f662c53e8568272201545aaa9f9724869b2d"
    sha256                               sonoma:         "ad54885be6cc3b484bb830597a772131a6c6039bf5f980b62e02646583480c37"
    sha256                               ventura:        "93b7f200779df076b9f561679e39aa257487f69aa78968559b1448427fce3028"
    sha256                               monterey:       "f2b6dac96d98708a72404d363922b2964a32981051ba3ccb88b9d12353c00964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a56028862c1f757e0a45fd203ac320f826eb80b468fc5ee60e487376fe5e4127"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end