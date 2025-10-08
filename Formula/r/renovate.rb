class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.140.0.tgz"
  sha256 "d4221a9120f4a552a14b3d0738475766ddc3320191a3cadb42feaf9dd4064244"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb58c3961ad813c9426a46e114f31abc2115882d576c185edffee260897d36ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b465d33e60587cdb9f4a2bad4ce2e00eabaa0ba16668d7bec84456eada4afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e42a81afa546b942b1ef8fbe9f13ca6cf5808e28124ac5f8ef4f15c4df9b168"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b69160b087a89e46f74cc5a6cc10fb81d579ec5a6df7d88263a459511e867c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d1d8b35779e61c30fc7738cfecc1e947d060ecfc32fab184020cff45c97993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f85af2d3376a2f25712c44da10098a7a6d1d8a7067260f6741444a2fd0f35c"
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