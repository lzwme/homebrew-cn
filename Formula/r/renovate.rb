require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.421.0.tgz"
  sha256 "0e20727260b184b95db38f3fddf18a95f60a0ff4d39aa5f25bd6c8b16ff65f5c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5cf702d666955acd1d7853aeaf3721ffed7e5a303c72f3e687caceda5f79657"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de1d0141d7695c575f4956552cb4da358129c321e0630bcf122da062490116cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e1d15574887dc280cadd3cac62e1f91c26934207350847baa32643c006c01a"
    sha256 cellar: :any_skip_relocation, sonoma:         "79496c63c8106cba912985c96c9e4fa170e067f85ff9b86540df76bde9630b0f"
    sha256 cellar: :any_skip_relocation, ventura:        "bd48aee0d0da3aaca955dda781de792c89375e705e280402673f0014da879171"
    sha256 cellar: :any_skip_relocation, monterey:       "e0f99be8afeae5322d6d75a484e04bf75f681f416d6bbc4a14f7a50a27dca8cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f580b2afa03ff71f98edfa99dd83658f0a07f2d9c37bead9522553770a44cf78"
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