class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.235.0.tgz"
  sha256 "17249cb15b4883c3c3c9b6fbb82dd55a1d2409944588198b802eaf3b01c100e2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00679e7f707314cf9c407862fbf30f02572a8cd5489ef372358e202aed4284d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e63d039dd72684235519acfe425029cc3a3d995f0bf5f32605befe34e89e846e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b15403524f86379588b129086aac0f1d940a17183f0fdb008154722f0907ca7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0138f391c8acdd8f1084ab46da098991e5d10e2079e6f8a486fcf61c77d9524"
    sha256 cellar: :any_skip_relocation, ventura:       "403b5f9e88f42d0a1634d0631fb8c37d7a0b18044b483eaf7837fa0c31885142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f28e48a1a2df20c790da5eaf266b8c4885dcb37090037f828b256bde961ca59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cca90b309a25c60fd0ad30b97d6b12f6ee6cf8035305d3bf299975b61c581d8"
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