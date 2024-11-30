class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.40.0.tgz"
  sha256 "d3bff37154e03889d5fd91c14bdc05a000b155256788c640fdd74e6e41410efb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f86fb90585320c8ed4395974bbb13609d98f40b6437ee24c66d57176f24c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ed0cc349c5104c6cf90acfd394577a8b9cd4267fb07bbd774bdc7edd80fd80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5493a8b6c48beb16722541ce14cbb010440b4ff78a536b1399d1118547328925"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd20047d810cb21d8d09fe0377073a11ab4134ac03f008bfc20620574c2b985a"
    sha256 cellar: :any_skip_relocation, ventura:       "db2696aa118660142c942ed41c1fa0c24f133c0f138cc3ebdf5687d4e1cda449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f10213c16ecfd747552631d4d4e7bc8bd9085e80afc953d71c828ac3af7fd044"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end