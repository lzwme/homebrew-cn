class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.46.0.tgz"
  sha256 "ffa7f77d5b94b99ac67e04d43b25cc201ebdb7e78edbd6d9c239378bdb78371e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92960e726875d92505369de447fe3e8802cad240b75d3d9aa0f088ccc6baff64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bdf637734fd9fce80ef6aeef3ac357618601cac4ae701c6341ff2a164e427e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1da7abf0a0c674600af06fe63451ea85d4d0dda6a77cbfd94953da6b6ef4d763"
    sha256 cellar: :any_skip_relocation, sonoma:        "1981ffa7438c6d27968ae408d85efbfb54b48cbe55fd3a6e92174e2d690f7188"
    sha256 cellar: :any_skip_relocation, ventura:       "79f2ee5b64b15fbbd21a49cd627f6b1737a7898b21a4f4b82ea78fdd709a7f02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b183e75338a25f690fb6ca741349f579708355f2d1e5a1b9f6971575104b6719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f7631e7527c902d3f5b0c87caff96205b2bd910f25a99dcc82f89cf97eec1f"
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