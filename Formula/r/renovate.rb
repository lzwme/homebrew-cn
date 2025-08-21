class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.82.0.tgz"
  sha256 "5358c98a392c5d795d3a8dd9787aa6928a955780f073f00d1549dbf8d2450936"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e464b6e921d7e2dd828981db9bc4470973533ed20a6e32df5da1feffc51b23c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1f5087dfbe364d9fc1b5170b5b6f0e2d2ec69001b71c93747327299bb2cf97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ae87164605903743dd0a74c7f7a399364a4fee97d7cde4b55df4bb68cbf822c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e90547ca8f611dec77d0c055cabe5d11537652c4a5251bb1c7d29136e0f9f0f"
    sha256 cellar: :any_skip_relocation, ventura:       "41fc1449722f33ee9308bc2965d809b31d41b8c6a426ac5bc55e216da2fbc5ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e31607833898b3b7db7f321b3a4a55ed1a8096cf5c7ea34b150052e9eaed89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390517d3911809e7e31ab5872539fae08f76711075482578d80876bfdbe7ab59"
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