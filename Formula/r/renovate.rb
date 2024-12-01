class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.42.0.tgz"
  sha256 "e807d9f459e23783ad364fa69140bb0c41855be6e603df1a9429164737fa395e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a342cbbcc177eb3518f5846a469a09741e6b5fd9e6b773ab729815c9c580ae3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7e0e7959f8e242d91223ecdbedfaadcec2f7bb2fa91fd5dd37ea434c246678a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "493c28f1a120e2c2ddc2608581a4b345297d7a5c19ff5ac29d2ee1e98f2303c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "990c878cedebf0af5cce1e91b5aa1d6cca8f7875b679a90dd1cf1348d9c1bd63"
    sha256 cellar: :any_skip_relocation, ventura:       "50417c906a0573147f1845a6f027b55c24efe8f76104d5275803fa47ea579705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "413694b7c303be92dcf6566fdefc1fb68eb79c9a3ce32b493c148d6ddf985932"
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