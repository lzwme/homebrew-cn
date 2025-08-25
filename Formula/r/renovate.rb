class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.82.10.tgz"
  sha256 "58be96aada7d80841bdace3fdef3ed42925a504a0b5eab342727710cff05d06d"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0755d96535faf8cdd29e30eb620fe35e81caad11e7e0f4c407d3ac645c27baee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a79305ea77c91f605748ce91ec6263b8da3c33219a90c56a6089a7d7b8dba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02755633c857296a78343d8f0880a40782020d8d900183082a1a1e9a7f31dfa9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27b7ed1c5d84b321628d190d437f7963cc459483faa4c2d64e0ffee79f84dd5"
    sha256 cellar: :any_skip_relocation, ventura:       "e77deda79e5128e4b900cbe33e14d1c87ce551b8b18c79e455444a42a818aa93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2460dffdad3714d792eda4ea305d2844d113df93105e587e8bb2d66b4e07f714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6258700dfc10667824ffdcf6b08994d00b13d38df319d725eb5d81772f1b9e8a"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end