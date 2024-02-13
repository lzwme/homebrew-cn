require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.186.0.tgz"
  sha256 "3da7fadbefa80cfac4b868c827e874d6ce3115f4069b5f9490cde082a441d00e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7da55f96dc97dcc1533bbac83848a5a2fb062717c1731c184bb30bb367ea28e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99b2432cecf6b632dae637e080cc330d655f4049233811d9d998f3ee9ed44ce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b30e12ac34e703ed71f9d46bac3083c5dcc9f4b67b6b6136e7ee6c958f440e90"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fcdf111c1e2884fcf448d2d158b185cf66f099c96c416c6b786aa8e519ea539"
    sha256 cellar: :any_skip_relocation, ventura:        "71b5a51d27a817ebaba10d73b2a4fe3aebd986b2bf01a809ed2f5382c4d6b32e"
    sha256 cellar: :any_skip_relocation, monterey:       "bcb1acd0c638cc7c57ba84a0cf49b75074a00916c65f23a4729f9c4f0e1a78ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79241cd53342ad4f39db548abe608376285664ed6d91f96694c2b93e8d3fbf22"
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