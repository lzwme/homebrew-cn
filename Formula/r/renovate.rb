class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.28.0.tgz"
  sha256 "a67c891ebb33366e1c34331fba84e530c00870ca1c64b279c254106d0f86aa9c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62cce5abb012e309ecbb2080d8982b175e0c6bca141638271ecd6d8daf907c86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a4fd6d85ec3c4243eef03af116fc18ef48d6ea789f2782013c3a50469ba0fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7517ca65d4b23f08cc54c51b8e99ddb94c7311c481871818cc89a871a1ea1bf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "215382a7e670f17b82eda97a9427069cd7e50959ef80be35bd0d2bd7fcc55bf7"
    sha256 cellar: :any_skip_relocation, ventura:       "e5155d53bb9901f397997a763f26f56a14fec14b5de2a2afba82aaf806a19fe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d40bf59549663214641b0668d19b11a7ed5b36f26082bab37cab1a509a34045f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c73acf40ade5ae39654f82ed6005ce2d78455160f0b23659ff6465ac25a19e"
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