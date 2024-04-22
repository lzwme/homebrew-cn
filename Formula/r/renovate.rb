require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.315.0.tgz"
  sha256 "e93b0fbe30172f1d10f24ebee4feea657670c277d6e483473196eba8b725261a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbdd19a73b110fa8bb55e055445521b30c9e8a4b0f6e1d9d646c2fe2ad8a8afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd5c86560f80b13a326d1f5d156f49e9188a7f05a7a6f159432b58bd5fc0b553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92a9d7ef9fe6d1b1b10c29dd8c135449c756ae8fe79cf5747b9abbbb8aa1ce7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aaa13fa94a30d146dbce88e042bdb736abaec982f1f43ae1e50952ed706fa88"
    sha256 cellar: :any_skip_relocation, ventura:        "29de65b910e0826f014240ffc3e57fe4ab4ea77b169519612179d84038bdd70e"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3a9f24f9d69c365dc26c37ccde1a3f39e03c54decdb41fc647c4772505915a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90fcf84a1c4011e407f13ffa55badd11f8c54d3ac6c739eb4130ec8093b908e"
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