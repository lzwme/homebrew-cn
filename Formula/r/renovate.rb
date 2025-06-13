class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.51.0.tgz"
  sha256 "c250c70b561a6461f980c9c4a1cb6d3eb03b7c4b652a422027336e4afe0c80ef"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24bc34ffa3ab61052baf169de2d27297b350850d0678387b0bb8241a658d6cde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "870548b37a51f05d17243cce31c2a13b479bd5acfe62931496d28fa937a88be7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d4648af9b6bda126bccf096b5fc13a21f85abbcc27b1951dec2820976b9a3aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "defcef4c0c56e56f11ac65ffc933a35e621d35ee9f86918eb0270ae2651233f6"
    sha256 cellar: :any_skip_relocation, ventura:       "630ead8984266116dabaa83a66dc9ced76445dcf1b6bafa2f4160164adfe3c3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75151a3d97bf14f467f8b97cfec73933013b4b46fb5f5d34b96847237752a1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8887311e4ecdfdf72846787fe6573bcd6650135412656c00c3da50ca899e217e"
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