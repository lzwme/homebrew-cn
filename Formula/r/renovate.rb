class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.42.0.tgz"
  sha256 "2d0cbb0c20d74413a6c546be3067d2ec2ac67f6d5f9022c71b6b6e858444be81"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07c9781db5b23dc44b5a1bbb8b6558b8ee0fb8726e75bd281dcd869b5101d319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443b8ff64370f762ab19379b9d87f8bc5a36c9b337a0d5aa4975e54e1eb4aed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "197afe6c3ce6099da16158302440ac15870ee9a224b666d9651962f197e29099"
    sha256 cellar: :any_skip_relocation, sonoma:        "66e1c0e1ce02ea668f1127437edf9f57653dac847e311ce21d7e24bc8aa7e0ff"
    sha256 cellar: :any_skip_relocation, ventura:       "87e1251c50f32b9e07c840575f71e6f9695cec5d823137755ad321960672094e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d3eef890e0a4925302c25fa4cb9d47090f8845a8f7fe6998d5808e5baa8c53b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "340fb208c857579c85f7fc15280d5832a3658d6654c8a50e7aa551f4820f91a4"
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