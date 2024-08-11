class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.24.0.tgz"
  sha256 "c3075e29af1c8e1db665b07796946f28220ebce5a5570f9f89bc2226f3f44f26"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7d645b68dc739b2ede2a9376d60a9243f0081afcdfbb4e25bc889e52a53e323"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b01e83af9b69516fab512fb89611e73fb760fb9f88b86f3aced21beaf2b41a65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50cc7a3566a498ae53e2a12dd765bab538c8e0bf41173a2a4d6fa4808b6f17b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fdca4ad55110913c5d028d16d66cb0905d98a1ceb33071660c271a7bc08a04e"
    sha256 cellar: :any_skip_relocation, ventura:        "267895e128086b8381394ff9d6f05af68bc0e6d2be851f8009ad2a97787097f2"
    sha256 cellar: :any_skip_relocation, monterey:       "6b3eb81a12ecc142a560cc229e84600cf499c834298d63d5074e47a4c5899254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c8eb57e736aca8b98f7fe62cdb13891813e2baf1dfeb52c38307124cc6c3e1"
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