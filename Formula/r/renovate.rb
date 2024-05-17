require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.368.0.tgz"
  sha256 "d93f9fbc9fe0f22b0ae58b3c75728c1f3cba9a3c906f3d83d42cc51f6adb2f7c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98cc78df8c00483275d8e4fcd654ae11cf7e365768fca721af91decf247d08eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c4ffbf8b828e3e33433694a0bfca4daa0429f7824ec49f31413773facbccd21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "167aebb414108def3cfdb7dfeb4e4556c52644db8a4fbf8e175b7d6c1ad8999c"
    sha256                               sonoma:         "df649c752650d897d423dfa4493317bf1225fd707bd6d00f888ab7ce6d5be56e"
    sha256                               ventura:        "48822498657ee2c57f010709951de34913a1a04e6c58e95e173f11d8ab17dafa"
    sha256                               monterey:       "c6b6d4c9fb1e824d14dc70a09e3021e81b33a59aff2a82473759fff155a21be6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ca5d9a4052700a6a55e4a3d54bb4f448a68ff3b7ced9e67e2a64e2b8fc57e89"
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