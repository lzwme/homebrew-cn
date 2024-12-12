class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.62.0.tgz"
  sha256 "a737b6a23d6062f6744632b922540e9d4ae9b866a0c1ebdabab8d43836cca060"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a700ad9789e8f820834c8d6437d9c0a9ee68d6395b594cbecb2b8ae3bc5e219"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1080a395af1553288d4a63881be0f5b24782c959e79c80328da1637fb9d828da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9a4c8f84f26a71b1e9be9583c7542f103bd2984ea8dd4cdf973a369887f443c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f5f3510d3173d0ec3bd731fd092bc6ed67ba203f04d8e6e3cf806ce24979d68"
    sha256 cellar: :any_skip_relocation, ventura:       "621b50902fe4a97fd304def7940a60bd7b1f9aa57801b83fe35a44cb0454360e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69520be05e075512fe15684599da4e7e7032d108136ae2a815d4d9829efeb513"
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