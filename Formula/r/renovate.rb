require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.403.0.tgz"
  sha256 "792d8b55c397a23944b459fd35cd55f78fc0853d22a3d860e2ecd5ea9df19470"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15c0417957b2c39f7ae0573fd78d8688ea5917cd839186c0b5e17f7d49be1e1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b36d213b09b8c160b965aca3865db6ad3e0dd4af95433b28c8bcb76fcebf07df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b52fc0c8f0872f07b93101770068348dd8a7ea99958b144f775daec3f4031c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb02552f8f49f2456b516111f8d94153ff2b95e0e9f7c710e88feb254ca24c97"
    sha256 cellar: :any_skip_relocation, ventura:        "257d47dd4c77cd062495728a614de416ec89b6326529f2e7e0d193c5c8dc5198"
    sha256 cellar: :any_skip_relocation, monterey:       "8cbd0e97bb2a62336d8a365c81c589d4b869f346c9dc86fc05cfdce8e8be740d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6caa9f0153f74951a2ab458f80defba46a617c58fa645079f9306562fe69205c"
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