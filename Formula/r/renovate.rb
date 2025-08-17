class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.76.0.tgz"
  sha256 "7c9183b5ad2b9bdeee39fcd3f2d97db8d8cbcee22f732bc8ebcd9d24714bc638"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d91a6a696f5b5b36899c15ffc13638a89436092c89a9e16bdd044375b05c1be8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c7072dcb61ecb9f881dc036852e1ad232cab1647b7d5ed4fadda12b3dc5e0c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1b705a1648d347d5b7529f2d8799bfa9b3482af28d8c55262b103dc2b637107"
    sha256 cellar: :any_skip_relocation, sonoma:        "962f385e8c332abd6911585c63b361fa4f68f218766aa0ce4a92cacaba978b33"
    sha256 cellar: :any_skip_relocation, ventura:       "e53ff7bf38954bfde7730bd0716a41e4feb75cad6dbc60b8688d1646f7bd3094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15338872d7aad5118a100c83df8959bec358fbcef5e465db83545d33f61f646e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bae6b657b043ffb957d0ec788eed4be7f77fa2a39ea644ab25f7e669f0ad570"
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