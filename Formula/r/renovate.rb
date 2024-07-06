require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.424.0.tgz"
  sha256 "a1718584b8090bb8f052b01c1ab2662ee7abc28262158c982bc8fc8d55d716f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d99129cce08d4a817bb081f0e81f6522f7d5c19e9b8aa45051c5902eaaca6f03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91cc6fbdd008a93b88f139a20872f41f0bf5833ba9cb42ad313936e3b647d7d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c333fb6ec7eed2aa8e6b2c53603f1293fbaedf3a159aef0890d4c302beb1be"
    sha256 cellar: :any_skip_relocation, sonoma:         "4854ca8b52c5ca961686d92b33b6f3a574bd8e3a0ddc7ceaac1395ea78f446ce"
    sha256 cellar: :any_skip_relocation, ventura:        "c8c0f9ce9b86c6a2ac64c574eb5003a2b3f3c909359c01796f1fa320072e01b6"
    sha256 cellar: :any_skip_relocation, monterey:       "96099ae4b0ed0502d343d7c2cf953c2ee25a11e3c404e564dd9aa4e05da6677c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a1118ecae21f747bdd47f6ea34541eb049dd285b8889c5a6f7c91fa940f9b3f"
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