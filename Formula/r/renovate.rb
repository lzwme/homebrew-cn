require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.146.0.tgz"
  sha256 "2e25a5e7b668fe6abf52cbb3793a5017df1d9c54478b9523440479ed46fdf079"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec39cc8aee007745808931796d192ec2d3c3c1f2f1cefe765b80de88d1599281"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8135b3fec3d43c685740576a06a558339c1d1168c950c993bfe3ad3f876e9999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122c3bc446c4e27c953442344896bba2c28e19f18dceafaecea516828a0798ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "2041d7a5f17130d15f929665f8ee9a42dececfe336c20cefcb05f6d05b4ad685"
    sha256 cellar: :any_skip_relocation, ventura:        "edf2b3e9258700ebda3386dd5deb9996f15ac49440663b02286e3e8349f042b4"
    sha256 cellar: :any_skip_relocation, monterey:       "c20e210ede3b24f1de8c2a1f67b43b375bab4b9cc65d7cd0a81a66f40c5691d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd5b32f9d2dc3fd1fe28a40f8e6bf0be601ec786bd3ce1e67e0aa5261f431e3"
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