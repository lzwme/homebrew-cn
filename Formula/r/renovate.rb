class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.22.0.tgz"
  sha256 "36fea2261d76ffc152e818eebe97681ed9a6fc499c3d87437483b77d7758e086"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa85e873f21b4d2f5f4734c2d37140d81c6e78488b2f549b1d6f34004a3c4520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b90dc5a8be7b1d519bb30463b0aa3521ed15d92f60363531264dbb7123a7fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5803134f9aedcdf31beaeb8db42b252894343345d85066a43ea6c3944fcc6ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "872a85543031bc0de7ecb2c01d2ac25cf1041ac7076930e85ef3a7ea1492eaad"
    sha256 cellar: :any_skip_relocation, ventura:       "bd83d2a67c4f861bed22a1a4dcdbe3346b55e48c9bc9931944a651d41f9840cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc30b529f250a6e412c6f51481ed9e37c536325f2bd6c16a20bc5aca43c69868"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end