class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.165.0.tgz"
  sha256 "58367899cb15b7fe2e8c2c28f59926cb796fc9e03eb54ee09bf7bb58789764cc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a249214ebf81a3f823ee44ef42529b92bb85da4cabb8199a019b62a16a6520d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478046231b3ec60786a27124f11e1c932aa1d77bfcbd385dc636e907c8aad5eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "05ac5923c37e06af6ec36deeeebe2623c88f458ef6bb2af4067bd85b484d1f46"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d56074a294816dfa6c585b0903b266e3f7fb688943d6d071e6a462901021798"
    sha256 cellar: :any_skip_relocation, ventura:       "95be58db391f76b6ab3fdeba071d789db4cd63da809c879950e4a2b7f6780ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0241614e25aa26b7e0cf195c17723a9faec66929b117c3577875ef09d13a9283"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end