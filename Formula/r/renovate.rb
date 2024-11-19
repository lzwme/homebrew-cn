class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.20.0.tgz"
  sha256 "294abebd25e1039a5ef138923ef1aad47c304382a06b7ea267fee660599447aa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b1f06d37fcc1572298ae45d52f5a534a57d31349912c202f6f6aef746d86c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "159726d44e1e43c76cd9e216ff49f29845e3a18ae95e62a77ca09d6ee99bf7ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8d03daefe84d9bc3bcdb52d01ba09fe43bf02786b5ce86d537974d9d5d265d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0a1ebf450516abfb6795260e49f1bb886ab9a359fd7b51cbb4466cc25ba2beb"
    sha256 cellar: :any_skip_relocation, ventura:       "9aad5ed96c1e7ec7100a607e0f757460d7fe9507b1343e69913c8091720e5e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bca3ed2ef384de59e575617baa1f14bc9e21e45ed750b259c34c7d38a2fcd28"
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