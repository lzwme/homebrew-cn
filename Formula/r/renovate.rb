class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.116.0.tgz"
  sha256 "edfe705ccde0a871d435dd075d5afe6201bd3cb3fe1131efcbb7e2254e57e816"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b36194c6738696bd372f1321f2e4d2abd5945f3b3b82b97115f92821f7545de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68a198649e1f2577a82d4ac7a1b97ad11e9ab4f8b0f4c4dca33063dab48f7b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67f228cfcbe2451b2d9c512c1583fafe251dc2b5b04b57b47c06e06a4d82d8ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc7caab90d361af9946d57562571774dbf7ef58a77ee3a0a10f8e2b8cf5d8bb5"
    sha256 cellar: :any_skip_relocation, ventura:       "343bdea75b2be88cbeebfd2cd69a8a9f6a611a1745ceb8fc23ae5cb3f81c97c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e28b296b6cda7e12b18731fdb34aa2a5877a50724c2124966ad31cc56a06920b"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end