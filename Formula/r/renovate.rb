require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.434.0.tgz"
  sha256 "0510a8a982562dc668a6683a01a47b323cc5b7981f9c2861c64d658a2b83e44c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38beb5ae3bf7e486b08965f9d1384446c9138a5c348cc5c14c5ff5928f23921e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd196d25567ee38ac25cc2701a74e9f97fb49d6b2e365fda939d9071e3274965"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d38a4bc6bde672c312315cd75a1ad89b0def2d9abe1aa196cf7962d8677cad"
    sha256 cellar: :any_skip_relocation, sonoma:         "f864d4fadde53e43b1530e532ea38401026ba29a011d2a6d73a836c52c4815a1"
    sha256 cellar: :any_skip_relocation, ventura:        "5405b598c5480304da6a83f0b91098151875237ee26c7dadd54104b8fde8dd20"
    sha256 cellar: :any_skip_relocation, monterey:       "e4abf0fffcfeb42b972f76194e960aa6660518486e34a2f7b6c1e684331382df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c20065fb36ef0ac4c7b13b20ad065c4a83bf2e05a17f8eb81cd02eea94369ae"
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