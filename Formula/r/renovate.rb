class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.26.0.tgz"
  sha256 "b3f9149a045828b83736446e8c42d98cab6ff91bb59b6fd52109c4fd6051539a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ffe0a43e560768408b48b42259e83b3cf85716e539ce16e499408b5f1c18e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f74312ad7afa9d326fb47d1a0e9ef62fe0c57e44b9735d62656986ca3ffb70e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07e41751970f939f106cc26d5182ab15d5e3e355d3fc97c4adbcf5e746bad0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ec0c9a1ed2197a424bd246c10d638a4044b4532b43682a21adfafe5d98b3fe"
    sha256 cellar: :any_skip_relocation, ventura:       "bfab3cdd26ae709cf66eeb1cab72e005215ba368528b767991823db6383537a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f64488137534ca5ba8808a36c5614f6e9ae7a070d0bad2d506295c999bfdf6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873696d5b7c44457d48f7e3b80f5e2c78e4d32cdac024c984add40bf0211920e"
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