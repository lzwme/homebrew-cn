require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.423.0.tgz"
  sha256 "21b23e365204d47d6a79e3e27fe8ece894203738d81391b85d02407396920b13"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faaae0ab76aca1baac7b85562a62ca94a4a84e7851127f13e1f7a4bed3694ef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e790d56763bd4ec6b75f8818471988ca0cc3a2352a13949388d631aced2486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "946ac8a32bbb3c0da3515c70f9bd0a54d85f245ddcaafa3e0d53244240103056"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5cb15bccb023435f719cc53d51b5364c0b47c72443e7bdda922787dc29d859b"
    sha256 cellar: :any_skip_relocation, ventura:        "1c599e3782c6623730fb3c650462f030a811af63c43cd70d9f61011334145e29"
    sha256 cellar: :any_skip_relocation, monterey:       "f49e5b8db48b4d8c776a2920d42e14b84dded63fdfc728bf6cf5247bd590b8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "246cde08385ae122f64f09f7ab9304b4c371ab61003753690dcceb6c68102c32"
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