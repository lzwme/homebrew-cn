require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.100.0.tgz"
  sha256 "f416900313da1be3ff060c9b7a6cd720d8f840a24138b394d0672c6a01153aed"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd2373aee476e4449c6f4c9bb2f6e4a23b7f80161603f4887369745c81b07475"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb54280b35ae3fb28c585521ffd27636ce6d316cdc8544f7f10906c8c36fb21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72115f86bb43e4607d15a373edba7563b42ba66d10a5745af4b014e1416704b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "448f093f03ea4b346d03dddd7d5b75c84f26e0ed1a1eaaa335eff4f8fbb07652"
    sha256 cellar: :any_skip_relocation, ventura:        "151ed64ec684d0e60762ba6e52f7756f8b01fb40896e1cd24e9a6f1ec1f799ff"
    sha256 cellar: :any_skip_relocation, monterey:       "3962334af77f36afe705cdf3c695d048b26ed0a14e5f9cdb687931753d981951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2255a9dd5b403706f0daaaece5aa1a66cf5513c13c8cf7d00b6b1f04b05afefe"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end