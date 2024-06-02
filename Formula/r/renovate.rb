require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.385.0.tgz"
  sha256 "b52e3730a4021f79bb69ca4a42a81810eac474314607c3370c8c63edd0df5638"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af542b630d0315fc1335d99f102d6533ccc1fd6789ede21be7224e45fc44e4f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeeb9460b281235607ff35c2d9ce356e60c36e1a0bc73957a5de8d04d965f424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84571f9bdb877567722f293931e051804bacbdc245b9cdd40a2262a06fc5ed88"
    sha256                               sonoma:         "368eb287f366fea9700a5f42b8a63d88f44c227d45563267af209b91359022ca"
    sha256                               ventura:        "026f4e24419235c5a7a9b0d88286e7414fc5e31756e7ddec82b2f25fc20b21cd"
    sha256                               monterey:       "2d11b8e5beac1ccb2e2ef461f2678da7a84e6b919fbfb9425d48a4054bb73e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d7a226b2e557041ddf0189d3ab55c83055346f4d0db65597cf975d6227640e"
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