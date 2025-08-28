class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.87.0.tgz"
  sha256 "5c9035132452ecdd851c944d7ecec48374c3d575702f528f95ac5bc963822550"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a91278c96d6655ee4efe2ec723e389037fa1101c561546298fdabe95e6702d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba7966b76b7a77d8f52e0387e59ed5f2a045b6e98492e846859ccde233035965"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c1051e0a885e2ef425fe335544470868634470ce969c20c48c27b639b021313"
    sha256 cellar: :any_skip_relocation, sonoma:        "f08f96505f13868e09116c5a877122a696ab009a8b09cf0b8f04de40357eaac9"
    sha256 cellar: :any_skip_relocation, ventura:       "f44c8786a40d3ab775860fd23424a54074793cf653bcdc10a2ed2fa1e1ffddb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c161379a8a828dbf97bfb08d8ee0ed00e3472ce53d429b350be506be6803ed2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af151e19d14f8ce2773045d724719cd62898afdcf95131fac17dcb16b4e36db"
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