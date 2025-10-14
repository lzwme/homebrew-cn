class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.148.0.tgz"
  sha256 "63a140c442cd9dd5ed65ca4ff575f21bed799142cc9a12a7f02686b289a1a386"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa65c3c38ebf15ad3e0db194e15b74174358c60c6b63d5a1eaa15791ec3522b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff5290b2782294a76a7c356f855dbb13b3dd52425d0f56686ca9aa8f263e72ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e1628d8f50426e7c2f8ef158905983cdcdf5262818df3c5a3fb3d351f4e93a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce3d16a2e7dd76c0376e3f43633aa9ee67d86eacc1a19149a6f02dd45baf7190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51538b500ca834c52f814d2f35d7dbb60a3c538efeebb400c23d31212032d4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed48f53c760f6472f4d0209355f6cf32aa9a79e5881b58da6a6e1af2f870a090"
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