require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.16.0.tgz"
  sha256 "a9d8844a1569e11aa839d6b393b08b080d67ccbe03d2954971f159209b46e3ab"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a18e813b1f52347cc8b2f5edc0c88d4a4b7417bad9473f9118b492b980caa851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "563f26f0feae798d5944df4054f101732125160ad46fe369d312dea1730c690f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab52643be2cfc18f5cf6fd420b5dc56fca4c6b64800b854c56d7bf80445d6a58"
    sha256 cellar: :any_skip_relocation, sonoma:         "97dcf6d0a450174788e5a3c022f725a3c2eee5757801ce8207201ea00005eaad"
    sha256 cellar: :any_skip_relocation, ventura:        "db67a42f0e27850d279b2507527b8012910e2bf127bf20f860b1b28e9b3d9c16"
    sha256 cellar: :any_skip_relocation, monterey:       "15e7707a50f366943378f42fe579336954c2add16b9d85a4d769896200fdee49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df0391e8d803e129a53055f689340e82f665a7d508888701f57cae5ecc66f303"
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