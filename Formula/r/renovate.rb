class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.15.0.tgz"
  sha256 "a2c882ba97b8678d34858ed9fe09a0d175980e63f28466feeee3288925377960"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91968cfe7ea49652a36ad174b266ea96aa5ff69c425f62d241a78bcefd705cf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4650887d66eaecfef558e621854ef87a58dc25c36bdcbb7cd668da07768519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48c24034be2e617fc765ed02c3e05b7b9b9f86edd070a9ad6b34449ec38c31d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c82359d32e872f85624f8dc37e1e7013924c0c465e7b8c32be073857849467"
    sha256 cellar: :any_skip_relocation, ventura:       "7ecd1d1bff942912c2666765b6aacdbff9a93fcb5f5892fc38ecd881cd31d336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21636945a2f95db95c7a532a42396d5e1370c4626b6ba889c2a0ab87a7e026c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe454da972317fc4026eb098fa3f6084cddae4ff399aecc1a0807ea161fc712f"
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