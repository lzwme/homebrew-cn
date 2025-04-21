class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.252.0.tgz"
  sha256 "8aa1d42d617e55b5cdefc7fcc38f7c78f677b2555b9c9c51de99e6029445cf5e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92ed962e4e14973d617de219b9c2f6d726cbbe3736355f3e09ca74b6f8cd1e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a69d10819cc39eed621811e7fc6064f14bea64008c1ee563c29e0fdd23f2132c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d76a39a72819ba139368db19e9a2f5ed5bb0ad5187d1d97a8efa3d044953e28"
    sha256 cellar: :any_skip_relocation, sonoma:        "3831f2829eec3b9797c70d6db0c1c7ac501b0fca993379e181b31cf810c7f83a"
    sha256 cellar: :any_skip_relocation, ventura:       "c33c4e69a8bc1128e7e3c53370ff66d3926dcebf3f8ab743921c60b09d28db77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4071dea4b2f9190c609a47030f25aa8147a93f5e7ed4f5d6cb4da9ed8c506aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d9ad09f6863d3f3b2b2d6fadcbcdfc08ba7c15df90d08a2c95210459f6b5f5"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end