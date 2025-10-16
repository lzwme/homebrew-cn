class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.149.0.tgz"
  sha256 "973100cbb4eec89a03a8f5939b374186694c1352b2c9db13d902c703bde391dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9381ac91311a1b186baec7ade29137b3fd02526362fd99a98b868bed59dbe384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "522ae312a04dcc5eeb148b6bfd03ce4e7b03a27fcf8df6e1788003af9a9281a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa762e96d44b888b4f80532796e86778350f12158658b6bb1573055dd85eea8"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ac49a8bef958cb3cff1907939bd6d22699e6c68fb9e0985e58e5898bc1604c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd8ca081a8d8ca632bd1dec156de7d8c44f154b8282d29812a50b7a18e5d16c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9612dce9cca43db2988fc1847bbd7eef011dd1e24e0a53b1e75c83adeb31cf3e"
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