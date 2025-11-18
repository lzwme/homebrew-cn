class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.13.0.tgz"
  sha256 "43dfaad63cb1786237048b2a988c6daadb39f9f9061c7f36a196df5ebf94e1ff"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c086575cf6050fcd7544438b3df04c9ee32adc563927a084d48166b16bf116f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da9cbb189708320e3cf319a8a8c98cccc2ae03e12e44d1e07ba5936f6bac313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75deabd5529d6b8cb4432acc8f29bedf29adea3fa954e7ea36bce0353031ab97"
    sha256 cellar: :any_skip_relocation, sonoma:        "68204046ed49234cac4e7e94505a7878686a7b129d1946ee80af04e9200405d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2d861e3a7535fe449b414bf77756b46c4a6c9a042a55e6f2e1f2ec44e4a20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cac1f38ff03a98fc036d377c0e53399dab87a94d31ef294158b2c60376675e8"
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