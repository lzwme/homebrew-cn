require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.135.0.tgz"
  sha256 "d386b56640f8c2ecf334c39e66820f8e772d56409b4f727300af9e1ce4f5d1b0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8445b5382dc760740e6585cb8b6b5893473798e5f7be7654a75eb16627a75321"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a9e52edec0ff78e1ae39be3562e97ff91c4820b3512c8fccceb5cba77ee7aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86fc898580521cefa54d046157fbb2a3f77b90127276631b5d35bd65e9c31b8e"
    sha256 cellar: :any_skip_relocation, ventura:        "28741772fc4a86a185ae4b9ecd02eeb26056a7a9f9139b737f006d669f4cd700"
    sha256 cellar: :any_skip_relocation, monterey:       "64b4e1a2d3a0ab71fd8614106aac3c916674481f4043eda0d14a019b6138d886"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cbbbb374adc6e582b35b4386cb01dfe5353e74d31b0602333e447e06dccbd92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5524d7c38f6a105ea6f8a6f58764294a9f5459c50fe187b8477ba01186f2532d"
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