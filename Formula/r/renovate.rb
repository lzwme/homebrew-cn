class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.50.0.tgz"
  sha256 "cd2dbf6b72d0afb01e726ff2cc4cf7e9a2665b80df007dbffdb8ca55d6743e44"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41711021ec0abbad14849c045d88402787259a03a1d1e5f7d04a9865cb209969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "542cf006b050fc73c4780671c86adbcbb41411deb7ca03a850d876f6b9df6cd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ffb48933ce72f61fb505fbd0535274fae6a743b7d8b8519c054bdd3ce2d65fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f54ab8200d5ce999b819da1770a7c265af69f25e01d7fcea662f5b68032e6029"
    sha256 cellar: :any_skip_relocation, ventura:       "314d74ac1480d2ae2419433779702c56603ec051b546ca367bace61648b8508d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529f1adf997328b47de52a4b1a9fc5371de8f7e06ee876100a5dd84b06aa362f"
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