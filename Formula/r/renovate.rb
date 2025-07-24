class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.43.0.tgz"
  sha256 "be0e800e4dc9a2877bccad410fef270fa87799138b0f3c7234c5341449edb233"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2fb5513cc52773adcf652276e664d2eb61ebf110d08c939bc422ffc5dfd315d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3057d995d28d71a6fd2630fc39734d8c4879cea34e234bcf2691e0c4168ede5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fab067dff07879c7bd8e67df05b35727b35e3cb1dec68f53035edc197cc0e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d572945e1e74a92da84bcfebac2229f14c9ed971277ebde71ca3d561e3fd6e86"
    sha256 cellar: :any_skip_relocation, ventura:       "bc79438b67ebbdc938b5e3d9234de867577c82e4d37f05a2978e5af411bc5950"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e1c1d3a46326eac8d9c6768079c69d323d9ff09fed5335c75624fc593f2b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6745496017f42115e6eeed6f6bc57b85526f3e562a39640b4f5ccf43b025bdfc"
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