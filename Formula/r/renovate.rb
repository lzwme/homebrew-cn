class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.21.0.tgz"
  sha256 "b890e296a39804cf2a3e2cb32279a8b408824bee99ebf93f4377d3d8ab49b844"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "461ed2243676ae705010567dcf0b44c61c61f9f318c0200851b50c9696ee8dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e275b354d0ae28fa1611f1ca05b6dc2766b057fc0d63c366a35ea4673dcd2d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86543991acef51bcdff50b8a5f810850ae4322a9bf3e147a85fe6a8ca247054d"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a31b924af1aafff631d39562256c48e8c648bed4075f3fa5e3e211de32af49"
    sha256 cellar: :any_skip_relocation, ventura:       "37693322391c366884bb9c1a362fd94751c383201e3ff56ce093c9a2ab08d38b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f4d4d015b0eccdb8ef7152e14c3c1bcc103505515f0422a6bf07439a5184ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e193ccd648efe48ec16a5fc8ef65450f3436f442cb7ec04a4bf812b058e75b59"
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