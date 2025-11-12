class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.6.0.tgz"
  sha256 "01b7cb4e2cae428248d546c1a54061d9d34ecb4af3725f333aaf67bd04071ab3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd42a3bbb3278a13a9ce61cf4c3c4fd410c32e0126f2d6bc1d28635153dda3ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ed2379f7513a7194e693f7a5e8817e2cadc7d1ad291c8088223e6f10e2eb16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a983828a706dacdcc0ea5d339c74976bc5c86091ac6b1892bb20d4a0d9d67624"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fc84ce95b1b155fccfd4f8abffebb970bc4560c715e1bcb412e25c940bbc149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ce9f0355a2c6443ec968255d4143af694c3faf49ce65f88e8a56922202860c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6e8cfe383a6ceef5636eea67cb17f1d7fb9deae8923b58c97ce8449c6c4f6f2"
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