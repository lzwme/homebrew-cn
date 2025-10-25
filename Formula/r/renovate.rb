class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.159.0.tgz"
  sha256 "543a21fd5cb4a83cfdda3d924585d464a32573241da9b30358c88b9bedacb750"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "855ee7c6621dc0a4ebce0dbac542e6720e92e11e41689477f7deecbdea01dc5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8b343b63ab0c7abfccde3e3653842b7dbde8e75a21bad45c38deda389b1535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa1c590bf38db44f75550cedf7676c699e2dd35b2ad9cb108b1a0410cb1b9991"
    sha256 cellar: :any_skip_relocation, sonoma:        "c89408262441f87c92cfbef4541962f1abd49324bccd468196863d3bc3afee3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e62fd7bdc7db12335cddbd6985092ea51c0ca80da6a76094ca178306db470a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d524f35a5132a80fb9f76563806418c8e7ffa371b29ea796edd4aa006517496"
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