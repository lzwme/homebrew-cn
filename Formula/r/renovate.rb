class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.11.10.tgz"
  sha256 "67b0996966d38f9232130ddf66698df826d02faa1167f2998ac3ba966a6648a5"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3136407a31636dc6f7acec3c7f144868d1bc7172e6f3348b4e5de8c0374e6bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79fffb93834a9a826e288d0ce42302250c33c3fa6f84c26583648f2bf62df90b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d607147f5c47562ad8f79ceae1c6cfcddb038821ed8b5e055f7acd3b4b2ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2227a6159136efaa2663033922b2948eff7ff43530d8a1eff0c7c34a813dce40"
    sha256 cellar: :any_skip_relocation, ventura:       "74231b83baf3a6e6279b1868432da981de1888b99b8203f45ead9a7cf77bd5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b8c04d3e9e0abb6c7e231b90848aa838a1522cc7090cc4003a145983a3ab25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb79f45e2acffbe19d36f25b090bb2dff98be1507c8aab2ac7d5d0a5ad72928"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end