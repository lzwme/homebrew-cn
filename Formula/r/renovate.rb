class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.10.0.tgz"
  sha256 "c4c0a1743e997af3183c604169c34ea40d7822aaa665b1e86fa4129b5755cc4e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d990800be2a9b3ab274dd2ace980f87559be097e4e4ee303a4837beb901f7ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843b0d917425ca9197d55988f9c422ee7f74f92ae52499a47f3b0f90b767ad8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "917f7d1b75306c6113ec3e4df9b45647e54ea5f273d3a8ca579232b6c3eb0775"
    sha256 cellar: :any_skip_relocation, sonoma:        "b568c6795f8b4091352c925a02f6cbe89f161ee8a4c4280b54621ef2c8fb7d70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6afe7d3d9b29627d2eeb4832b0c714f1810a41920b6ef017fdde530de911cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb9c01a4426356490f7fe34b622df9dd645c4b2cdfe5cdf987093d2a524a27c"
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