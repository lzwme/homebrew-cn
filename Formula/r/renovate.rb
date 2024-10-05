class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.110.0.tgz"
  sha256 "f5f548fea39e68cd8220e07e5a076ab592a75bbd4c68981870d8549b53c90229"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e72b10be828124be91d592b0181a54dd4e0002fb9d112f0933350706ba64f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bf0e39b8abe042cbfca3219b151ba3be86fb366f161e48eeae4dd50a8f5a697"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f72efac433e973c07dec8bfcdd18b6de4a976e4075d9520c7450046284113543"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5051eb78a91d90e99a02e691bcebf7e2daec021820f96a99162cfddf6936acd"
    sha256 cellar: :any_skip_relocation, ventura:       "7cc48f7db9d07da425e3aefd0d81098153ce9e5faab374176bef2554d31c9288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e9acf95683fda0c97a34e168cad4655ee3b44d23db5ce40a8241be8207485e1"
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