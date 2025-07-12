class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.31.0.tgz"
  sha256 "234fa872de28150845a2bd102ad932b87bfca41466f6788f978d8ab64e269e11"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2328fb956fce2e734748e0a1264aced456d175801cf7ae8f2bbebdf1d661fb1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9131d81ae09a266507c2349b948e01eab42eb1b96430d026e16b6d6e0fdf4593"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce70e95ba5095e9fd7fb888d9aa440309a098faae9336fc8fcba67b193374192"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f1c04d7b51f4140d4bca8c59b1d1d78183876ebf3c8ce73bc07148d46645ae"
    sha256 cellar: :any_skip_relocation, ventura:       "91db43484047b35c7a52089b14e09cc9695cf703da319b6b353f8f6648dba33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83449a48bf749ff1944325acb190e6ea2ac9e187541943e47cab11f5a2c1eab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76db1f31d57a0bbe9cbfe57c66a2b4023fbfecad6f547917d6618e35ae359bb1"
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