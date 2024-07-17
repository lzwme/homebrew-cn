require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.432.0.tgz"
  sha256 "29fbcfe65a539d281a41b88c7307fc6812b1050dce9ac87a1c8da9bbdd43c6c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d207fc99b880045d1ef49f3f5e15b8fb4f264dfa09d5638caf35d619d4139ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fac98ee22788903e25f029e7bc514c1fa41a0049b9a21339fef1870b052f50de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51a2f4e9b945fc4afc2d186d4ca129a719cfdf0c98db3bcaabb39b14c2c44cb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "33f77a0b0de937e0933b5f3255c972bb68302656a881816d7e60c8ec4526c2bd"
    sha256 cellar: :any_skip_relocation, ventura:        "63ceb2833b994a65a69d6b1369d073cf485b1f7cfeb9e44d16fd02ffeb32f419"
    sha256 cellar: :any_skip_relocation, monterey:       "71c39a13ac8f3743f78bd9a3024db02396581eed956bd991b56a9899c32bd17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623a03f75de2a44372c811734e950b2e88bfa7efd7ffb23828907ee93610549f"
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