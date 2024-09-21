class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.91.0.tgz"
  sha256 "a6e418a4a3734e24a022f206d7407da1e793c94705ca93f85897d3481928ad8d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36982cbe09cb8dca9a177b2c535d6dcf01d6d571e3245a18c99673c705a3159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "402b4fe32697f71ac5e073cfe3152b1c4386970bf1d39894bf9d965aad98d1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3311a1dd03709db65fed73176f871bdf42b8a6cdf9c91344062842d8acda4b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab6db84735afb6e312996ce826625bef27ff466e175af9e3047b3fa9eb9156d"
    sha256 cellar: :any_skip_relocation, ventura:       "c00e87b64ece59b9d895a045cbc928b4413ec38616f8ed84e847591d452305ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a2956afb998dd7cbca8def0df50de1d334d96fd5bc4c3f1d4b2511cfe0b093"
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