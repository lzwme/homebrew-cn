class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.115.0.tgz"
  sha256 "1b2e0232a20b0b145b9b2923bc6ef421ef1b31e0d427ab9cf633505973b09727"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "310f804ab8359f255b756e2723de7101cc01cbfc8bc21c3fd9c2b3badc2da65f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "228c8863fe5c7673ee48d175be43612a392fdfd7e58d648b922fc26b25f6a791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b540d9a01de33af75d255292377cee7cc807bc6f8a6ec6f2595846a0ef7a2c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a4bf107c9c983a114427d5942ef2e31d23a8881acf7eb30e4b3adcdf63f64b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09cc86e4d3e357bc872dbf656922bac88d2e932ca27b5ecfbecc591810224556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f7ee62d1d8e1cc6efab10f4bd2468c9e392b09efef3c5078c2834640526ff3"
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