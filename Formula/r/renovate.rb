class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.62.0.tgz"
  sha256 "b72bebe49ec18c152a17fd3b7ad7f17780f7de5acd0480b399b4fcbc0034485f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b8fd74151254b3df6bd4f6900236dd68126476ed10ddc2a3a5bace7cd723ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308831671b1cce4af26046198598e32dd9b8a54cf5a735450f09e5b5f4296606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39b506d3c5d34855cbab772665c133d3cb2c7c8e76535eed5c90db22b1069d34"
    sha256 cellar: :any_skip_relocation, sonoma:        "d644e201749dd2373dcbab1b5e27dda82acafa3cd4f1d33325676beb5ea39dfa"
    sha256 cellar: :any_skip_relocation, ventura:       "175a710b89b1a719eda2e6758c98ed2f6a794a27591e8cd4537d25aff1e37b78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae82fcf021cdcb81caca91ac4ba5bbef76fe9c63936ffa7921a692726cfb3ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c547b8b2df0db78426da5494a4e7f2e956cc8b6bab88ddcfe73fe8bc4f087331"
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