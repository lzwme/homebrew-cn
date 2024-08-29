class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.57.0.tgz"
  sha256 "b11295f2c22e3b4fc91ccc6b4cd07af5fa39c18e937a0eae3da74bf90c959939"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bf99d576327fae53541b988ef02551efbe079f463a8d1e46ee32f1d41986392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4675215f745036e411b4ef23e995d5b2f117a00259260907d127e3fd89f45c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "659304ba9f646b3f85e3162aa26e7c8f726ed62bcd69876683e995632300ea47"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c003352e46ede4e8d796ed773e575a66dc52963e52e393118109586cb5a6e27"
    sha256 cellar: :any_skip_relocation, ventura:        "6e26436f710421e5779d0ba5118e49078f5fa3f3c0cb1231d55a861a9a229dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "8c068d67771af23198ccb2179d0e010f3a766ee49b6cdede511212ca61b8d04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07daa167db28bf673037625fa73a1540a1f36bc6aecd4cf63892a9ac940eb6f4"
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