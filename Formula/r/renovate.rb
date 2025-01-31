class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.146.0.tgz"
  sha256 "3cde516acfc0f19fb498e26d6d7a454f902353fdf9906a28b28aca35009f467f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551c0d1d785ffc16486629fafe5e07b1ff4f4452e581d653dc25f71d43086e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bda99bb4562308db93967197ba90c088e9ae9e0e5f92964eff9ad28966c2a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d769d0d6d915941b66e180a45e2ecbee990bd84328c7f954e5e64981a9f6ef3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f473963318ed9afd5266d6c69cf9109b22f6fa29c663c3f0b8489311662c14b"
    sha256 cellar: :any_skip_relocation, ventura:       "a6ec3bdbd03188f2cc059abf2865a68cdfeb94de429feffc36c5a88bdf4b6277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba99652e730dace538fa555c0c471e5f28db3012992f68d9f78abbcc7cc1a2f"
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