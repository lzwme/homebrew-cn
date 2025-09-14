class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.113.0.tgz"
  sha256 "60c90324d84779c0781e5cd6850421e6ea5ff8658eaf6234cb1fb9c3d2803e7a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1497b36e07fd519988329363ba4a2add9f52c858e2a9cb8c617b2586ff2f93bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46211279a339dadcf2b1ee2e05471dfbcd2284c9c1bd49afafcf0baba7c487b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c279420abbf0a3a138c24f134768df727a9c1b76088ebbf64424832aaec9ee1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3540b992d188fbe912d57feb7e14a7b9e1703e23ea21cdd440bdb757b18825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0f01e5a2f55f1222adcaf448626d5beb36759a15e7f51b38c79194befb198c"
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