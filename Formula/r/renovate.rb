class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.163.0.tgz"
  sha256 "0dce2836d6ed7ca0e95456d121dffdc4e4e33c10ae1c9a272a48025638514421"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20423bc2aa7c0a027ba35e2ffca4149011d05bc2bd601a50ac90c909227ac1cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a92c8adfe9fc5ba436f39723aefcd3614ac29ad6731ab059df7d2972daa3ff12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9989cf96314a9a358666ae6a41686186315cd9790311f8ce8dad3d80efd71a54"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ef0aa7d35ec2206336a539afcb5c80353b5d4379829153c79545e457e2549c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12606d61dd400fd567447dfa9b36c4cf21afa4c9cc07f1f805c60c143119b042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65f68a432ad119f65c0b3caf3cdf3aae01b2c180fac3e19039944175d03a0bc"
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