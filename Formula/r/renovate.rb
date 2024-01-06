require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.122.0.tgz"
  sha256 "b6f2b9022ba31934e799b86478eb0c038a4804df0bd85f32d743930c817f571e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b0f5ca8686d7fb686ad29e458c655ca7288556240cc125c929eaf11abfa9899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa123820fd6e921081dae2a629846632213522349f11d19240e5d4279c159990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c176f748813ad692ef61aa56eb7e91918a5fab7aa7eb9ddbabf46ceeb1a1f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f87b8fe3cf2d48c13cda07111cd466fdca43cfa7372273aa42452e7084a6955"
    sha256 cellar: :any_skip_relocation, ventura:        "449e729c0cfb4ea1856430019387dd4177491a8014d9c619aa42b381c790c87a"
    sha256 cellar: :any_skip_relocation, monterey:       "45c3dd5fa6e81e2cd1c350e10ee4e92762a33f2e5295996b5e8270d9c0ad3610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c542cb83acf47442b69ea1e754c5f7b01c3430d81e7d43be818fa00167a067e7"
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