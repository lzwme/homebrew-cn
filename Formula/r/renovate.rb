class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.51.0.tgz"
  sha256 "c9d23acee510b977a638b1f4772439847bb8632158d996d11428c616cef928c2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276a74d0ae62b21240e912527e4ac627e66e2f83500cc5d25460cb363e83328a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcb10853b8bbe90e6df04f4bb0da4928fac083e85d747ba57d7334ab7a2a5210"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d395903b4c88b2c2b3a06657266eea49bb21d72a9e43c49bd7ee56f13924cf16"
    sha256 cellar: :any_skip_relocation, sonoma:        "e451a59902c5d6016a8394ace4530308af9388cbe103fe04bb659b20b2c7e0ae"
    sha256 cellar: :any_skip_relocation, ventura:       "a6de25966e23847020e2318973d52b93056ee20a05726485ecbde27cabf69882"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b249c9410b14abdc205b4b59c7749e5063799771bc919a6c44fd802d8ff203a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df87ee103eb93d23b79238083c9da8526727cb9df0351d070f2e40dcb141d44"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end