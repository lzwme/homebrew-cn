require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.407.0.tgz"
  sha256 "5d335f9b17483335cfbcf51ddbe646f66fff2d0fe09aca92ab76b172c684a1c4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe352e505d9abbb78590515dcf8a0b7bb1c070683c06bf39672fdbd4df1b8459"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a94fcdae1623833c23b4504757cbce814f46016cf15dbf702e4636bf9daa92e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23bc512b45e4e94e053b7c6f604a45fd7f1c666d182e0fcd23a981745f5203ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fed99cc0825f1a2d900e0f2147e961bec20beb9203ebb30c6da70030d1434c9"
    sha256 cellar: :any_skip_relocation, ventura:        "38c7a5c27d046b6cc0516ea3a74a995b52c4863723d42e62c3c9c72035ede8b3"
    sha256 cellar: :any_skip_relocation, monterey:       "6825b608acd3e06ca66b6971c021e878c16e4f08b20f11d6a046642af592723c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207e01e370948e8cd70adfbe71887a81caf92651711ef96232603f9fe63efafe"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end