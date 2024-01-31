require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.162.0.tgz"
  sha256 "b748f7cc0da022e65ddd8db3f4e105aa0fdd568c69117b436b37f43921f5247a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "077610a543f6c14f8d1f5a032ffea2f248a5454b2dc2275af42009f3290c1815"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f100aa9e3a45d5468a139f28b61d97183496a6f71cf6c694ea72d2d37bfe55ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee372d5ab466dba12f89bffd8c199901b132336f81c9c2ca41279ec6c9e2f9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e532879e0d71e374c02a9aeb98a0f9acba45c1fe2c7bf184215deee4d266690"
    sha256 cellar: :any_skip_relocation, ventura:        "3b091a3a3f3fc8aaf64f2806c8781efe329a7cbd451fdd15dc4920b14c42008a"
    sha256 cellar: :any_skip_relocation, monterey:       "c96a13a1eb36fd148a909ef04cce6ef80cc5ceb4d8a6380928f6b7555ff0a688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f18f3df5f77f44ec798107bb7824b19be873665b335ca4808976f18cffa3bd3"
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