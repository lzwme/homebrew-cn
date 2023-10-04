require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.5.0.tgz"
  sha256 "8fc5ac7193816059cd7784ea3d61a62fb0f1ce39d3e67569ffbf79bac5019ae3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8af19d617a36c55ecf36db47b7f4945cfba591f75ef4afda47bf239811c09da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c310f1ac37dd8b1d60168864657947f29a8f766c886c73f8449d4097521a2c52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783128ac039e3d33dfc4b839add828f7b1aabe5faf9927e827187f45a7f6d0a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f92c169d87b7bcd678a961e45490ec0a31206976ce4ef5acadb63419e88b831a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f480c03255e6c941f61b47affad2a2cae7efa54a03ab8b1025879f6f483d074"
    sha256 cellar: :any_skip_relocation, monterey:       "4968a923f623a19f84cb028b9a052ed20fe30ac64d1466e3bc57bad257c50504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d8aae3d87ed34967c12a549d6387a696f1fb5b9bdce6895813acbbbda9a7af"
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