class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.34.0.tgz"
  sha256 "44b51ea6027aacb1fc7f4992d58f853633fcf86c71a5f2b2fc06e19a6a47cbf6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1926b9d70abf722e3768734210469abbbd9ff1db305c01bfb785f2c7ed7d8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d17b493005d26bd51747218c22448a5f16a79abfa30f232b83bc92ba469ffd92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99ae5386f185412e89f24a10d990ef9e766b1b22f106531100548398a60b8e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "a32fbb82098047f8fbc6ae42d9c5c48e21a3c27454fc79a11f1217296a61c225"
    sha256 cellar: :any_skip_relocation, ventura:       "405fc3a5628850b50678cfc7db752fab3566ced38e0543fddf0d1135fadb828e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b671414978712f467781f8f086cd7864076c8034fb47ee2b7415db0d0f34b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50e616138d8b060b2dd602094e8720761bdadb9955ac076051e098b29b594162"
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