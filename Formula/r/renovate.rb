class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.34.0.tgz"
  sha256 "c0f8019605b690504a18d77103493107a55faf4dea4f6ac08b30482b84ee465d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b313fdc6a837be252394dc0c577eb74da1bba24a42946099cd588eef2bb8ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472625c83100296735bb06474b688c678cf55eccb699730ad0f05711cc678925"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "668e3a3e9873229eda9fbbf1500103eab63abae8baaacb199ec94721802bf5cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bcdf767a9841314657ca30103551d9a81d370275364dd50ddb4acbd133f9ec6"
    sha256 cellar: :any_skip_relocation, ventura:       "d8259570cb0c2577553ee211f3c0fac4396cffcc62b4d66845a2a74796fc482a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf32f71293001376a0aaa669a382ba00d00bf2d88c798822ccd21a1c8a2e12a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9da812f2cfb52f5dfe78b6e7231e15b8208229e42cbc02982b6304ad7cbf54"
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