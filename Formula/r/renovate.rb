class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.87.0.tgz"
  sha256 "d1bad99efab662bb1bd5603f1e003cb259002ce0d4594f4937bda15d7a9ab47c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b690dc16c63f2a84a3b44152883efd88a227e66ae5305779598a4a8cecd6de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f908ce9c736083c7c0faa4c5e4cf891a11cd268724cfd095de10b94b1fd1b92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25befbb4cad6eb4f134cccf48d345404b7efd08b581ec12c31f1c599642f2a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab42464833a5a7fd480e4ecf3663fdd3d75c215134954a5482aef21dde805f2a"
    sha256 cellar: :any_skip_relocation, ventura:       "ea455fd64f35993d813ee2e0b66c72d787d4b5549d334ce61ed06380b5d2d45e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17c681d43bc60dc745339b7903a8a55285e9e45ef99c97a4b3e8568ba71f958"
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