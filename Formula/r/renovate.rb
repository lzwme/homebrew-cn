class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.126.0.tgz"
  sha256 "b33fbacf7c7a8b27b8f712f7c52c0a0f4c711e87c96732c68425ecca652d6a26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f47cba2f7097ca6fd0a0925417837a124bc1bd28c9d55051c643290b61982297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef0c76320e996f6ce36eef67c8fca7c1e2f8a6c1504601d6c765427c8b3511bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03c911392a2aeb312351f63f049fcb516f7a860f6b509ddc3f8de89de3735d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5a135143b2442a841c7c343acdf452884522843011db0aea82828d5055cd4ff"
    sha256 cellar: :any_skip_relocation, ventura:       "6878be3873f0af7f8ff48d47611fc7d98eac0c911287e4dd1e0f86e2123fb89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d8c0120b89a60f34a427bcfbc25f7d3d83412621921ef0eaaec3bd91d647f7c"
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