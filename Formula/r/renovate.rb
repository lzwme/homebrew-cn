class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.7.0.tgz"
  sha256 "2b2b6b507b135e5a3bfc6fa54ffd3f7e3f501418a879c1184be2c8bd670354be"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afb05e6aebf6da45f277a67587669fbd8e56e7a4e42702a08dc99421c88d653f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "098a2ee1e97ce2d878cd7a5b6f19fd9eecefa3d343e75f82a3c289c4226e09ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d68735f844a1ea3360029f95fb6111f8b0e50a50d157949d37f17e615af8ebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "37005553fd47e95363e9cd4526513335651c2ffb3957d4396fe89170c31d5f10"
    sha256 cellar: :any_skip_relocation, ventura:       "13a41232d0db3beeb5ec5133cacbbdf20c6b4f0de58af506ed5f728f267f093c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dae3c0ec3c5f5300f73a14b0a200f5597af79c3507acfcb498e0854dc813f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef6b1e7f6f783e09bc839c1cb3679a6126ae60eef933c33071e6b49338ad91e"
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