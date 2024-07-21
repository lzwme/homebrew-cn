require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.437.0.tgz"
  sha256 "49d71d26de5b7f3fdce37c232cdd74b1d1600110b24ea16b0a53f55e78858cb6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa810972dba5a193f0b5bce32c533028e90449909c6b6cadb9b6a3443417fb07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fc552e352df979c75de7fa9b5ad3a04b1431a940a0fda028d99696379f262f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90e021ea89f7156996f81fe3341ef5392c9c3551268021bfc2a10c706f957320"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe1f65434476d4806baf8df88da490bfe6fd3a2e7a97a8eb7663d7c1afa9740b"
    sha256 cellar: :any_skip_relocation, ventura:        "37ec8cdb2636deb78cb8da70944717971ce756c13075bf6914c66b72d3a8b714"
    sha256 cellar: :any_skip_relocation, monterey:       "4293a87e3f8834eef900be159a918c98aa37e09fcbb0ceeb015a4f0e5dbc7393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf08d7b7b3495791256392d01bf02243e771aa9bef536d5764d1fa7c232693d3"
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