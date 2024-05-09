require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.351.0.tgz"
  sha256 "8664ed758b76a4ef1dce5543200733a8ba3084b674b74ae8f16d9fedc9bbd272"
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
    sha256                               arm64_sonoma:   "1bfbb644d68eb2f3172662ddd55fecd0b58c37976250a648f286626c992dfe47"
    sha256                               arm64_ventura:  "a680101ff31f5926b9d75eadbf78260117538bbfd444d6187a1ba3a9dbe774fe"
    sha256                               arm64_monterey: "ba555d3a27f2819e12f52d54ed9d3cde99660b453d70c67d6bd640c02cf22d66"
    sha256                               sonoma:         "dd4315fcd0867aab15e780bbc09f21df1c97632ada7d2a4031c5cac0f02c8df9"
    sha256                               ventura:        "3f8061205d4a70cdcf36671c0ddb99474f2172d43a1270d2933d3583da40762f"
    sha256                               monterey:       "189506d15f765cace806b0cae29fdcb572bf4a5f895447a8b1c3cf9d7123171a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2073c5edaeb6cd3478c854777eb0ca1eba8b62e411447c28a85ceed0982f5f73"
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