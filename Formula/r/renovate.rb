require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.342.0.tgz"
  sha256 "ab216f0d45af69522134252936376857f8da82333c4b94a01bcfd3b4ff0b23ba"
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
    sha256                               arm64_sonoma:   "881a7462873f7930561b5f4dfca906472e1966e800d0f3a8e05d7271c5ed2c8e"
    sha256                               arm64_ventura:  "0d929bad24a5a754ecb4b2942a1ec4047499b10307ce56065a75eec22c7d7ecb"
    sha256                               arm64_monterey: "db0e2e3bdb8d6cbdbc7a5aab933b7bd024149980c04dff09e97b62e2e28b2e7b"
    sha256                               sonoma:         "f9c701af4afa369879515cf92ef205d9138f79d65cabe0b1a942dffef20fe95d"
    sha256                               ventura:        "e88f7d53168956d42ac737b6b2aab50dfc18a4c451b25f59a74be0f1166a9bff"
    sha256                               monterey:       "d44c8068f80047bff8bd7e4fca73b736eb0bab2a89ca7e7c7f42695019cd8a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "441a93b59435929a1f23acc26c2a61575cab61b58a08beb69221a8eebd0a195c"
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