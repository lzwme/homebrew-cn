class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.170.0.tgz"
  sha256 "93b57c2b184c1369d5c5c497734ac79fb993b34edeaee6f3aea31bdf96a7126e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f665e4f0904ba6568a86a52b158f1206640235bce81fc8bf5f342cc422f2f660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c242e8fedd7bcc7dc59f81d6a095363e8714b42a5fd4349d257695f3d74788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec437f683e87eae141764dd8dd6dba1821eefd4e72e87d4d3119e921972e985"
    sha256 cellar: :any_skip_relocation, sonoma:        "108bf61bbaf4313842bb30c6cbd3c8932982ca1cd14c59eb14e62d2a6b3c0123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4584254c62770b4309fb98e5bb2fe5666935a9c55b091620ca86e4bb2c33ad25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ac4f9106692b4a73c8cf41f341b2bbb0e7ed58d07053831097c08c4a74e90e"
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