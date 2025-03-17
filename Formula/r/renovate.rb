class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.205.0.tgz"
  sha256 "90a52e460173a9e9898d8b1484b4914e9203906a5a54a6e9589a8d4538f9666a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b90ffc1e606f42cfe1ac6f8e8a65523ca422bf79c059af437e04713fc37be1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a301ecfb858b6ac2e7e1760fe3cb6ba2ec3d9cf5b8c85f49882d47714c201470"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d95e4ff6e340298fbf92f393111ef3dfcf48cbc737c78e30e4dc44fd95fc794"
    sha256 cellar: :any_skip_relocation, sonoma:        "c81275017a61494f5e9c58ddac2d2240d60b6f6f3c57500f0708b1027a8d5f3c"
    sha256 cellar: :any_skip_relocation, ventura:       "7d7a553aeaefa394ab8e56b21c6cc911b2b76aa3d97f52553e85fc55cba79b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d14de42b9b6d2211afb8b0f0af32d9cba3b4f78330c61bde04e6e73754341b4"
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