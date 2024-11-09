class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.8.0.tgz"
  sha256 "d8f9f6879f8639c8d61acbb87dd7d1aec372e4cd3fea22796d9f71af38815b27"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20ebec12f8968823846de156abacf07bd62a921c4867d9da450d794c9225733a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be1f9d1990f91231673bddd13997e0bf040a51df149be7d1de18d091a0e0d31a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5074a07a6fa0f64c6dfde41e2ee24ba7c1c2845b6995c496340bcb3078d153e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e4f232afaf3a96a4aba49de32baf4eb76467c6894dce0dea074dda4a56b20db"
    sha256 cellar: :any_skip_relocation, ventura:       "7880aa104bde57f7570f0f11541c5df348977b68c76ce314d78a4c82f815ef82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21202b2eec117a3816e672e231704a753c35f1716523b20cc7530ddf6e4b2daa"
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