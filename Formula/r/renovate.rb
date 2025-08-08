class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.58.0.tgz"
  sha256 "466ebe141788ab561a12838f4a36fe10a2c340bae83892da2ede906381f9cd63"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb68910d1f554a6402f2feb33b617e85337192d9c6628190b3c935104b5e10ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a7e44963011367e25d287ced538d4d228a457091e12ed708c5a36ee3e004627"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23682eee13b671e698e8f6a6b3a4a5821cfaeefd69e631bd44acce6e275901ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "abfe570aa10b9298f2978131e93b585c224b9f0a263e2a6ea4ac58dcca4d6721"
    sha256 cellar: :any_skip_relocation, ventura:       "fe499a6778cad8fab887dc20461b6f6b65eacbbaf70d4d6043044fa656014111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09df26089be8c44ee1e837f1cf9dcf9a24658bdb1c1c2ed88f80ebacab8768b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "833f096a9f2b3eda1e8f2e8a262beac93e16f5d0e59f4b0addb5ae2bf2fcd772"
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