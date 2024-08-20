class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.42.0.tgz"
  sha256 "a32a47fd83ff769f6566dd87104c270b4d03decc7a1fc01c45d889dbf3d1ad1a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf3b9991caedd9e88755313e58bbf9a143f08f05808811339b0651137a6871d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7df80246e1d17c6e3581d4e31eeb41fdd31c136ebfce6303fca31d689e6012a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e5ec0fdbb0f031910161b4f9a10c56b24913b41546b0cbf679073ef47fcc022"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e776892739225bde9b363ee88c640785caacbe228f037b4263e610aa96c8f67"
    sha256 cellar: :any_skip_relocation, ventura:        "d1bb9e9a6d5c5b7d26e4714eb2fe44e50f3e6c8622c50894054c07544a5ed6ec"
    sha256 cellar: :any_skip_relocation, monterey:       "de84c5fcb64e9ffc89970fa48fc5d319d176bd183cd949e864d712b4dffb8e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b222462c4fe5ab0daf31881e2f288e3deecb12e1d27dd102b2920cdb679d12f"
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