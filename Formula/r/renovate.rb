require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.175.0.tgz"
  sha256 "7a2c9dbc3de10f729f47139b8c5973472cb8838dfbf4921d6526dd03ddaf01ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddbc4eede5c0c1da38088d9676f5069f63a43cb0bcf4924dc3078399ac5435b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d872443ee5625813facd075d7a6100385e6ff921110ed0f865c0bb3fe18d9f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e166bc81cc04e7d3598f28f936b72a8ae0c707c1d9ef6c46cf82338860d4b3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e51fd31624f532acdc08fc010e967208df4ad75eb2490fdb2adda7c59f2accb7"
    sha256 cellar: :any_skip_relocation, ventura:        "ac1516fab76c45576c4e66e2ff1996c563c4b3e6f41cdfd0d12f7d34fb3e2ff6"
    sha256 cellar: :any_skip_relocation, monterey:       "d50b19c70ab5f6a9c9da612f85f6c005e3df7d5733d9864da26a237068bf1995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74c2a038ddcda62760be626156a75a48df81f663156f8bb983a81b0abc9904f6"
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