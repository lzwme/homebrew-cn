require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.9.0.tgz"
  sha256 "5c60b23669fe999cc933752b58ba4c3c76552333ea85f15297bd6aa416cf3eba"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "903c2160dcdf6518d64fef629a5df63b535bc3742903b6ab51b7b30c8042774a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b890e3318c0418b8f7826befde543459b96ad611a94c30abb72a311236b0092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47fb05f616bfbe8d59fd903bcd79e4de256fa58f57b638f69b8021772ae627c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bdb8aa4bc8987a9e16379110cb98aef2fbd8dbb0e361580b49afeded6095da7"
    sha256 cellar: :any_skip_relocation, ventura:        "dddd30c86d5cc9a00c81351c3f1048435076884f74e5aaf0e893256abc41b91b"
    sha256 cellar: :any_skip_relocation, monterey:       "c6207d4c7e6559ce0d8dfefbc7c8fdc741fbef28b0092845324e6dd0b1fec085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f1b0c115fbcfa38bbc50fd9be1f9da7a9fb3740f61e5f1d67c8f059bfc8994"
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