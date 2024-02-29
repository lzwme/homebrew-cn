require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.219.0.tgz"
  sha256 "5acea0683368ff895caad1a4299b85e030232947433236fe0e71bbb8287cf7f6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3b5bf40e592497c254efba7086cd7d6c598b9e90e5eccbf38947aa7f94c30bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc8590ffed6fe8717a5e30a16ea434d883202d36d4e1ceccc6a783dbe7feb22c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d645e70adad98c629cd4a08bf60b0d4aa16e8b00f0543517e787b544f57b94f"
    sha256 cellar: :any_skip_relocation, sonoma:         "5de8b078abc55e5d5088bd3682a286a98ce5b3afb709ba9160394591c722abf5"
    sha256 cellar: :any_skip_relocation, ventura:        "38ddd1e2d4cb41184342084019291aea5148893a1c1742221225c84708e6dfa5"
    sha256 cellar: :any_skip_relocation, monterey:       "e9dd068efad14adb9d281343b4a9c34b5f328bf27047a33e01b44900bfadfaaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26a71e96472d5020827afabd094b7150539f7353285782cdfe2acf2b2e5687de"
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