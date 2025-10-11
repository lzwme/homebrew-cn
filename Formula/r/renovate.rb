class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.145.0.tgz"
  sha256 "486b21c58d129de7da33a0fa294bbaa62a51fc365e52943b4d525f2c166aca09"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386dcd1032fee4241429ecc7feda3e45aae0a673ca3e8b8b9bd761bae4f935ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb0a77a83d2e62b10c8b77757a18033a6b5e3e9583f164e5c1d337f306e0f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abfac729bf7be0ef46bbfd3289f72a6baffa5a46a442ff1f172373a425c5ae34"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ec0e411d4f3c11a900d8d1c1a9f11c8aa74d042c0f86b9cdf9e0600b7605e3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d38699649d27ba4ae611e3af4707f9a6b388d918902e937b99d2835f98e263dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329fc0c5350bf4f301b9cfdb40c10e9631889787494a452da5d9bccf85fbe3d0"
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