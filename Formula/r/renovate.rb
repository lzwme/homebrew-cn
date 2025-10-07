class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.138.0.tgz"
  sha256 "81fcad94671ca206effec15529f7d13173fbdd369df77bafb189039ef6e3a785"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1f70daccb78e90321a9d657a98231aa24a0a2fcd0cd43f3cc22227dd5e8c6d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76522a125b33db8e8f23376859c237e8cf264fdb830e823bcf65b19063b5de28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb773762931d4e85a7f514620d3b0f62c496eb69a1a9708b36f01f5b46ecc15b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d046832ceb7b5dc6bd3513554d51bfd80f29e422472c441c36d25c6517eb98c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e0ac52c815e08de698f8af1c0693e16891883da91d8b65fc6186b863ad4910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "887922b05b55965b5133b9a02bdd14b961a7f234072d4bda30474d1e08b0e7d6"
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