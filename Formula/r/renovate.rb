class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.233.0.tgz"
  sha256 "fe9d1f9d2caf31d1237fe5268579d32ec3687eccec9fee30e922c09750b2d613"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c675364dd5b3be56e3395e05e0359be633a0f02a0920e60370b2d202dc28da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a019b9dddd56396d98730112a7e2f235c95f092f990940c23351ec27fcd7d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c14e860633868152df6c1fceb1df56ccc326b6c0cfa2b76c90b18c6bce93673"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe81e032fc08168df65b2cd0ca9d7f00f2ff27f285bbf4a832f7f5655b00e203"
    sha256 cellar: :any_skip_relocation, ventura:       "93f8fddbd72a45fd5a7965c34480626a727c95e3054861a8eebce44b3185d7ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540b6cd0ca459c16fcf95f573f3b74a9af8dcfedf42a1c34057e25f8b37e3932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49aab80e77fc2457c3dbf40466d185b86a6fcbcee095eb85565bb3280be65483"
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