require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.60.0.tgz"
  sha256 "ee62b56e5b3d224cc093ac53bdc86b0387693e87bff6e6b442a592a98d9b2bd4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8c40a5b9e9e934b30307b7c9b53507b1b662fcbb64248dcb10d6aa282b68c74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d14728ae585668ede7e7fac5e8613374093460ee961cc12bd6f2d0db247bd5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cae595869a3e56f743d12b627cb6757aa2f1a748340baf0095e59f7219b84af"
    sha256 cellar: :any_skip_relocation, sonoma:         "5af4bfa6d171c8127ae0664c3cb165639302bdb5e6dbed427915fcc7979404fe"
    sha256 cellar: :any_skip_relocation, ventura:        "2998d015a00830f05c6588e205afcb7df878dd858e6cc773eb421c8ccaddb535"
    sha256 cellar: :any_skip_relocation, monterey:       "80703533a9885b35dbd91f0d24ec7b0fe4931b2635760c5b4459815e472bee72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d05bdfb4ef247bf4d51fe91a7d2d8eea3015db5c3780d7209d131dbb6e5aee"
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