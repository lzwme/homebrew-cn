class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.253.0.tgz"
  sha256 "9ad87c68373ef8d38c95e3549c67627941e393e5900b604abbabcc383ad258fd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92d1c41d5fe7cc8360d2da50ab7f40fac10175442b83e1f0dab76cca10b1fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f6b8d466047ad45e4e92e06ebe8d9ddc37d1a4346061e2e8dfa82ec3b7d4b95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "705b76744dab55e28c07f00844cd11be59cca7d5b59e4abdae187d8ced8698a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b81daead4ce64d55247bf9236e0f6809faec918733086eda1aa55880aab76681"
    sha256 cellar: :any_skip_relocation, ventura:       "be99f8c86967798d88f3c712334f47407a4df4cafc228a12e2c015b3490dfc06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7c5d0b7ee2d60a36d80c4fbd616b1de371bc892a9bbfd1aa6ed635ab5e29888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c36127218c6a32ee53524eec2d4b303ea39d16a7601c44132425eff8964d29c"
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