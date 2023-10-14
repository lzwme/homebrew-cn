require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.18.0.tgz"
  sha256 "b9caa59aabea8123b39363186be008141c5ce80bf053df87e2f746c690cf8c4b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e44d111ed3d69aca3ab6f1923b57dd698f63189f59876007004d93ddc085f9a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad59e1fa2962cfdc1664f2150960e8de9f9c44c265d99dfaac1f094a4749219d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7481d7e03207a118e63edeaec9719a09796cb1811b49b385240faccda3d9b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f239eabf10b89393c6ae84fd39c43b86369a9a974741b122a13a06e2bc43052"
    sha256 cellar: :any_skip_relocation, ventura:        "e69a49117b04a290f7e1133f05274d1b7a3bb227e702d5ec031989144c24f3cc"
    sha256 cellar: :any_skip_relocation, monterey:       "30c376fc1eb7b349fbf29e6bdc72fd21dbb491afeb4719b179325447b96182e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6036ca2641f0a5b7c7f91421faa147d637f8170bae890f541cc285c7cb15a02e"
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