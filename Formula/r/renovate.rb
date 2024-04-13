require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.290.0.tgz"
  sha256 "1aed3ced1f22b288aac7ec2558212ce936259ea1dee856ca2869a8ad9789afe4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7800a43e48b138f44a4e702b8343cadd878248ab5d460fa6a73e01c03cb94b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cd077fb5c1dd05d22f474ffea15a68f57c44d7937026531c8ddd685c97637f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f704f70be74286f95ad55e2992ee8e3700026aef944975e10408d4b4e4736d20"
    sha256 cellar: :any_skip_relocation, sonoma:         "367a84a6798d4404ead1b3c7ab894f12014e277d455dafd7b364053e00659632"
    sha256 cellar: :any_skip_relocation, ventura:        "5aadaaf854037e0710bce2e8f2935e307e3e29d66d140df441e87d37ed6fa648"
    sha256 cellar: :any_skip_relocation, monterey:       "5439b3f52ca40bd0d8e20d9ed8d53fece74a725d063f083c872e4d170ac045b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94433fb5206fe7177ec97f720353bb5b575c13b6165368ccbfdb8478a8a2b1fb"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end