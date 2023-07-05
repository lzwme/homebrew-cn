require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.0.0.tgz"
  sha256 "00e47aaa9e8028abbcf8268d9a19367eb3c5441ba833b0e4bbb1d02ad894e696"
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
    sha256                               arm64_ventura:  "2683292b6851c35d6800d16edeb4f16b6c2b8aa240bd557ebb1f7d644f81cf8d"
    sha256                               arm64_monterey: "3825566992eb0f886544b1735d252eb2ec7f16fea0674e259786ef24977a16b5"
    sha256                               arm64_big_sur:  "ae42c49a8e6bd578d8f97aba183b17eac62dfec17eb2b5f6773605cfaffc978c"
    sha256 cellar: :any_skip_relocation, ventura:        "55cd1372e6e88ea677463a3960ebb2da6ec1d20672c19c9b7fb888e181f5f2a2"
    sha256 cellar: :any_skip_relocation, monterey:       "390f9740854262736b72aa7d47e82331e5965f0cab41404f93ddfd424a8747bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "61599099fa1e0883e657b4fc95fa153248eb56d7c32dff4309ff16a31863019f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e8455962885baec751e6a38ceba777ee1526ad5f7c44fde771283fda898353"
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