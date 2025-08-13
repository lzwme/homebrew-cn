class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.66.0.tgz"
  sha256 "9f4f313e305fe158fd14eb8fcd09907bbc6dd4b11abf60fee4284aa0f25ae57c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc90e78de5cfe0c8f4cc08436e857056e1e829b311e41784cc7d610ec0e846f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3461ce1099c1f07929e5ac4951a68c913d1bca6eca009919ce1424466916a209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c0c3d68fad20ae0b06047500ae9892d6258e56e5731e96f326c9882ab03f4d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c6c8cae4551d6991b4fb21301a500d2f84b2535349cbd7f189b8f7c44444a4c"
    sha256 cellar: :any_skip_relocation, ventura:       "34e2fe7f2adb6fa7ed1cce6bddf963543ddc50ded0a87366a02d2e6c95b5782a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d41f009b450bb5c42121a9bf09d012b1c1307f359aef074b8c60354bac93261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b421b226d7c201f4bbb245e3cd7cac95cea744f38acc68b570f79bba997b04d"
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