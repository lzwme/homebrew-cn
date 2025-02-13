class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.169.0.tgz"
  sha256 "cd0e1a20d06272e29dfa6600f7ffe48c0e3a2cd20d9dfbe0f033aa71148356ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61247d36c8d9449c706f4e48a6a501337c7a30978687e73a444bbc382c0b6616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbc6e8a4aa817e80d6eb2bc9c4742b89b2674fd1327b75c5153fe641f8ee0b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "328ddc0312215f3e23fe829eb793168b25ff27d056ba8642719cbef136abdac5"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d1b9c8e683fa7fc642eaaa52b95f185522f54f66446003ff8b7d2ebd828b46"
    sha256 cellar: :any_skip_relocation, ventura:       "e786acef51fbdd5453a01c1e7a613d62274094c77b11cfc410164307ac99fd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f48dc6ad7f13136a8b61eb37a795a2817ac4f4d3e745d425302a81944a4903c"
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