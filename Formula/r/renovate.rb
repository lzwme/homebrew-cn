class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.48.0.tgz"
  sha256 "03cc87ce9bb785c341b7f7b9a8eac95c318cefca763f5c9a0e1c617765d20a7a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e387f50db447172b6c824300bcd72dbc5a807d28ff57c856f08d267fc14d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ae75f16122d6124aa076746bb14b0b8c4febdb71a8580a4b931b053be9578d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dc4a532366f4a5a212a84e563e3b6ec87cf6881aac2a997ef5e0d3fb2c0af42"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad42368ce96823476aace241feb1a217750e9c68dc42b4cbb944637dd118ca7a"
    sha256 cellar: :any_skip_relocation, ventura:       "b901e86db70efc06134c85e5537f94a505dd38ffa2d85956b4897e962e51ebcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f72efa990198eb6179a651b5241480d9483928b2d1e137a1c0722a7a0e1932"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end