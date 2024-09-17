class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.84.0.tgz"
  sha256 "5456ea0ba17e878061835ec0471f9b1632cab1b312392649475da5edf1023d98"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04303883b2817e5d07972c355ea21fa1f4f627abc62aae1f42079eae61ffb1d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b65c7c2ba3b1b68397c635d34f7e859c184c41cc91d12150efb192e0444e04c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b0895461a22a1d52b2a73bfdf2cf25d544a5e561d24f37c57ece2627c2b01a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "24893c45ad47113bd6c0d8b0002283bc72dd887a95bf30d3a9e5c24928016149"
    sha256 cellar: :any_skip_relocation, ventura:       "98077741ac671676223550c0c686ecaccdb93c6629c40383caf331b7337d217b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34cc0c3208186156e20b1018187b229c7390db375f74eb8768648054e0790502"
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