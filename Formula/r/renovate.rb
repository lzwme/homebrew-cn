require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.121.0.tgz"
  sha256 "54316ccbe14b49c1350d1640a7605f85a1756e7cd639a96f83b143a5e04cac9e"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d031d6ae1f02b470c6305da266b42677e3910333c05c862892b782890531e484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fd87c42a3150ef130b6f374787720b7e1353a4ba1ace7380dfcb135c37e0ba1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45e1ae887727eda87943a152811bc94420b8e6397cfc6fc19d2217853c439539"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5cfdb48b6408806109a102bf15580ed4d579bab5095162797d56a28301aa7a3"
    sha256 cellar: :any_skip_relocation, ventura:        "b616dbb9c8067bc002922753c4e6839fd05927f6af1322c3fca25feb28117f00"
    sha256 cellar: :any_skip_relocation, monterey:       "e01641bb5d4074dc716c8e09373fcdc26724c7e731b245fa29ab835c579776d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3752efabcf8dbf490a0790247f7e005ca3a8484617228118a9a3e98b053cf769"
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