class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.146.0.tgz"
  sha256 "fe2251c9a7d81cec41c6958332e40b51b855b65d51a01c72a4dbb1bfff5c82dd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4011c422f82c55d591c962eacf028bceba999126c5b377e1341cfee1af0d9900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbd6d452399c5a35d88603a82b2ecafe5699139df4e6f841fb895b52cc70f9ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f1dec4667635f0907bdb036cf1128a3eaeb1dafb14d4249bd49aa9d519fc0f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a59ab29af45f3884e50aecccd2df93fa3c7837a9d42e535cbf6e4333dde37e2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45920c627dbd8d4813499f022764a6e91cad29907b33af2bac30237e188e1430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e25d0cf4c0f56cab664a13d6c5d7070195bfb39f18b5fb61cd318fa122439c8"
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