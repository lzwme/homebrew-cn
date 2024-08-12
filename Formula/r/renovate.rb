class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.25.0.tgz"
  sha256 "f297a0364f6bd437f0e80d0a539bb4367e3300edb81cd627793742c1dec28500"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31825d111f754f2be0b61e4efe9671261e23229df114b02be30dfdb45e4456a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a927e0f13951a9fc5c0369bbf17cd1fdc787539112353713a86b2a620047ba0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad97a222b122fbfd95b42b00a3444425d42b2b75b48acb6a58b2c94ce5fff11"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c2c9de481d9354edbfaab408939de2efaea096bc5345a06941ea987cda1a5f8"
    sha256 cellar: :any_skip_relocation, ventura:        "04f9d2984967973d728f996000c2425903acb5038b659d93c3a0705fd4b664b4"
    sha256 cellar: :any_skip_relocation, monterey:       "0def5d649c2028a5f05cf52f6874c14db6437b059bec5e4344b176ce710e2033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5b6ecc5fea8ba9f482d9dbd2d2953019e18f8d950ce883f2a9ad5935b53b866"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end