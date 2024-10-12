class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.119.0.tgz"
  sha256 "8c65b5c59b619acc26445ec906b0cc0e8264f685cbf4037f8e1e4c5970b066bd"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f3e3a311816f3c1426bd73d4d34acd1427e1a0073c18d1d48c69272b90edafe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75de3e71f94542d828633b6f1929158a59dacc66df84d9dd63b5606bf2202a4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f574c6cc019d033411c998de5ebc55c8606239a9ffaf816ddd101d3771393dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8293b204831923a8b76b607ae6bed9a293c4c282b2b520477fc83314e6306b65"
    sha256 cellar: :any_skip_relocation, ventura:       "9c430ed7e6a8109364ea326d9a584ba6dc8e22ab1cd1a73e3937b126ba427d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af55579c866c8ee25fc2972cbd4402ee355f3635927acd5a0025d3339455ad9"
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