class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.95.0.tgz"
  sha256 "c2d5d592bdf6a8c2ce650eec9bc7e3f62dbc6a7a4fde859a5d1be096ac58dad9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f06adc097363a03882dcb32fac802c9a4efbb694719802c4fc6682712a881d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f0cc03e13c76c3dbed14e3bda927e3ad179590ee5df5b22e7b72f6dd024919"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fffbe06be3b3f70d027326ddb53e2bd24011c960a9087d87423596bd552a84d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30538cafe22de38d0eb0182164327d86aa9a5d9a5124fc5ea53f24d9cf21722"
    sha256 cellar: :any_skip_relocation, ventura:       "6d9fd1792e543c0073e1e8199d312e87b2afbafa9f8e55636e56b631b645bc44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1dcb0bb05ba8524cd2bd692fcba3588f8e0650dd48a306130b3c55820d26e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f9439c4c854022b23d1889b911523fc7346841bd5dbacf891c9d5f9054406f"
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