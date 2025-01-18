class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.115.0.tgz"
  sha256 "2b57cc19e078957d603417b138d3283b1cb818f521f6a148d8e8eb3b46f7cbd5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb98b566b23d592b14960583ee63f8b1db2d2434134f7c9f89874edee02e1e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8072ccf42fbcba2f6b0e174d9f97fc58221eac93acb73aab19ffbd20a95029d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4420bda18818c580d91a3d1d503cbfa258bc4a31f798f0dbccf377520bb3b359"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfcea622fe7f650061c67b87eed172cb316cb8acfd7e871f56fd43b30f5184ff"
    sha256 cellar: :any_skip_relocation, ventura:       "aaf3f72eb623e1b41708743b5c28c001cb7735485d389543c99bd1047c586884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85acb93919ec887ee1a0701a147b6dbb5bec796318b167d6990d15cd0ecb0a9"
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