class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.166.0.tgz"
  sha256 "dc6d649bc07a00d93f4c9c747fa71c4610ea90e89c11d59d2259ee740ffa328b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9544d2fbfa394057dd012c12e28593be3f76ee62bdbe59b5470c32be31345d50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f377c590159000e1a60ba998082f720b86bcf7e4fa5d3c9833c46f802b951609"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e309dc19df2eb5326e1ce8bcf43ff3c23077991eed677ca71ee4db9cc687943d"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d01171554647b266d75d6a3f1117856093f1b6283482c1b937a1dfe7de14c7"
    sha256 cellar: :any_skip_relocation, ventura:       "44b9529b6ee423f6b96c69225e7ce4c368603ba955df06efb0fd35768d174691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "309b67fc914408c750752a3f01729f086cc20b93c5c605362c1cdc6505e6e827"
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