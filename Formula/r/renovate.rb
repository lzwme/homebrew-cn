class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.101.0.tgz"
  sha256 "2953bc085c66f3393320c8612b6fb4ba10b9154eb2a5573d6ca7a00332a52eb0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df087ebc7752371544e6dee625b8fd7e85fd323d3ae8ee9f9e313bfb571dfed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf2374076a22f53b8a83808f79b51d478c8c99349c8e8b7d8de8cae7c75167f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fba5831e399bf629061c5f381c0b992ba2025c552956e488fa0c021934e48ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9da3c1db875204da1dc57b6278c92213bc4d035a3cd2860deed98658758a250"
    sha256 cellar: :any_skip_relocation, ventura:       "abdf8ac8c27d8e514448c37ac1fd68146eac8e18a4198f90d11589455a13aaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc1b1043510f28311bec9702434f7de9bde895ef8605c9de5a71e4f1643bf71a"
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