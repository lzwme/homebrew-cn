class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.107.0.tgz"
  sha256 "6b2bdc4b820c4594d24e10f90ef15a2583afb757d9f3ec1333af5113f4a060f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "808073dee9ec4504740861d0706329ea4fcca4b6da96e1027c29b379b7e4a87c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b12cbbb2e71047b0dccfbe7e795907707cfc2bb9101ee441e8b550e75bdba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf48985281aafc889882b7920f3cbb58293c08cb44cdaa55f0efc0b24404c5a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "637ebca2e4b1b84311c85c5ece6f883a99e69d13bc5e84200f2f371b9a657ca3"
    sha256 cellar: :any_skip_relocation, ventura:       "d7fde5f18571c43bdf1fa61c754b8fcf546437ccb510af0cdd0641d118274f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7701a48bbd714c6ec3fe6dcc536eb5b107a7cd0cc131f3a38437e107589be9fd"
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