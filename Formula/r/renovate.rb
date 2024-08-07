class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.19.0.tgz"
  sha256 "d24e239cd3d5ff5bd33463572ae147388fdddb532712a836ce70ad677b3d6063"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdbf266b629d9e4b49f4bdd630993c04dbc61d90e2263eeeeb8473012de52c2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f1f514bbe8071d36af86d0e51f352521705ce74376c97728c1625c60652d94c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b1c7f141e1080f06077d6486cf95ffdee2f42808a4b3016117025cbb47db1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1c81db10be609afc0a2d67ae71a283aeabac981d88e88f1343ed4780a7c5811"
    sha256 cellar: :any_skip_relocation, ventura:        "2b885f7c69498a733b26622674cd8597a537d91edb942f1d34085a47dca0dc26"
    sha256 cellar: :any_skip_relocation, monterey:       "01dca0f3873aca6390c2f0995bf412118a1c85050b756da6c1e6d4e934ef4b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57d6a23e0c231d5a57ad6cc389a51a8d6855d352cf2d46a4dc627dc2190ea6fe"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end