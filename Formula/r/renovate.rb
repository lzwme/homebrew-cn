class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.40.0.tgz"
  sha256 "7a2d0a9614b1c299e376e9555ebc960eff147350933d2b8956222c115b0d7586"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88a709b564a9a6d1eb4ea34bc944504a718c2885c0619b82741752b1da9421ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31eead1e4b5017a305e89b7f64d2608077163fc168df371d8c2088f7fa960f10"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17dd96399ff5a27fb5e5da01ec7aa885019f22341a4c551de98595abf3e21ca5"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c38908e1916dba11a8c915421624cfa1d3352da99297d13d0dac813f463fd0"
    sha256 cellar: :any_skip_relocation, ventura:       "3d0b4a6796e16d171a792627dc412186ea6514f4ddf603bdd8a68798f80bcf67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f335352c9f1c6d5d0cf60317ccb2d271e789d3789a4bdbbda636d5da922180b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85300669120f9419b909ac89d3b9fee2e15e6461ca1c7caae8c47ff440cf4fd5"
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