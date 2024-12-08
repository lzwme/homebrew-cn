class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.57.0.tgz"
  sha256 "f7ec513d060ff5d348706e40234c6ca1ba4753e537140978e9938ad1db09aa59"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42d2c32fb1865295f44e9aa29e1549faef99c9b8a0435076e79309864c995771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c77095a0ebf43f6c3334720c72ad9abc08ef74204070f3a5e0916a9bd7c9ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f02f6d0103750f6a83436a60a111b26b4ecc495992897a731973f5ecf3e5c74a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0307f454ef31ac75b35dd23af7df2ac7de2bb2539c7af590fd81dcf62c88d0c5"
    sha256 cellar: :any_skip_relocation, ventura:       "0ef9247f9de93dd34a7c27cdd1568767e4bdb5c48cd594cc157288c8b4f59687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4321416ca462f09fda9ba77150bcc992fcf2667b4ed93fe37d0f1ae879cd23a8"
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