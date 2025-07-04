class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.18.0.tgz"
  sha256 "26e8924eab2d31e429380ebbc7cd4bb016b8ee4122a9b33ef613c71191c9bef2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a811b14e2d6afea10c448b417579e604c1a35645f942c1463f0d6f504569fd88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa82a82a95fa913a0ca2848b42f44f804ba34da8312a7d523619225502103708"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ac96c1aa08a34dcddd5d8e632c276ae1efba42730059960a837fc05a357c80e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9d0503c16642daaa0c3a968ce2f43225cda79b4f6522d466f70bc29fb6d2177"
    sha256 cellar: :any_skip_relocation, ventura:       "7138099f77d0bf38f57b72438e978f68d2e700900bc032322a4b912959b7a30a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7ca34122df345e983c84e8217260c5f624b5d56de7aaf95c9f460c1f766155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1078a06bbce94b674294cfae7d3923cc8e084ca1e6b96e6f6cbb70e56c2efb1c"
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