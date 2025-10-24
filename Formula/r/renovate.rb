class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.158.0.tgz"
  sha256 "185c10d3e71d22e283391d782dc974bcd2f6c43e3a69f016d067fc1cf88134fd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dbaeb94810172d94d7067b11a98c3039cb6beca154a3403ed0351858104ba28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9019ce5942cd76327b614fb3b97b80a644a4e3d8f80eea0402677f6ca8529b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7244d0390cf64019e2e3b6ff733efa43a4348949e8f10f837a7fb440b1f4fc83"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c6ee76393bd6b27f06d3aa5a437a504e08732432ffd119eb6bf81ab2c176308"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45cae24e1bff3321e045773340b2eb663ce4ea01389e78d603ca4e9613daa33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3242b726c8cb96acc580f0bea746cdad8b36da3fbf107d2c8da3c2d7072df07a"
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