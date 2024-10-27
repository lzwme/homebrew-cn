class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.132.0.tgz"
  sha256 "441816a64d6e50ad28cc9710f62fbe6678dab3bfb46396772764c2acfd4d83e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91abe9aa6d5594c087dd4011bed5450d537d0208bedcbf44f1998227c83bc93c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1350966660b4a1023ce37a3ec2419e1ebe1f686c40a4bfa03e9ebb5beb26ccfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4556f07ad173cc571cbd90eeac72319b35cbb99547b9c3b64f066adf2b57c9be"
    sha256 cellar: :any_skip_relocation, sonoma:        "056931d9fe959fa893c157a263ecd9fa7e6773a044967050575614397fdd8c05"
    sha256 cellar: :any_skip_relocation, ventura:       "274ae40b7ac89ca7edd67806c6dcc4399e7838b69a79777aa839b21592b3eef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ddfb626b63239cc8d2d2eb9f418d24309f68be6e88180011b3e7e8ac51882b"
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