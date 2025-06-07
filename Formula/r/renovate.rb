class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.45.0.tgz"
  sha256 "015a8860e8e6aae128d4c6bb7a1cc8512f9287508836b9e1442659a51f576b2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6429b8b98380a855336b8d5814fd04819d7b57132e8fa3ed6ff7c5a897766a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4983019a980e1e522523916f9ca6e2ebea1bcf9f6c29a18d959b32aeafbd745"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9be796594e7f8c0148156299776bd9e89938d7cd229f9950dcf208e593636b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1faeedc79bb32bad2075c1a4a19d9dbacc1786c46201e938af6a123a17cb8e27"
    sha256 cellar: :any_skip_relocation, ventura:       "1b38eae7cdea2fc9a627880a137be669b64e5de664f2cdc077fea583fec7fdb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14c3b7b788d8af41580b387405bb201bdad105262e61b3f1918b6adb12a2ba3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7894f7e44ccdbb06e32d9dd97ec47bb8e4febdffbb96a82ce2d60860881653d6"
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