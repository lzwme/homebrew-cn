class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.133.0.tgz"
  sha256 "4d3e77aa4ed6e0304c78629eb214901e2ed59a199329182dce626adcf6a7f0bc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644efc18524e7a3290c219b3b52e466cc738374a18f6cec1275e769825fbd3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38892dd46ff8f1bd0745c0baba8885036fdc24ccef4cb96ecba6bfd35ab9c13f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "560139b618ea155325ba4ad6f068e1f9a6b6ceccde41cfd3f7687a1d5873aa5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "36174ba316eb9c682cc3e877b54facdad92612f8ce3b24c6bf364c100b97d3d8"
    sha256 cellar: :any_skip_relocation, ventura:       "50f0057d7a47e98bdd3d293233bc2cf9439b615781798fe2072f254964b43c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d272d31b7567cd888162942c94250e566a5adff2da6b7e41fbf4b7546cbca127"
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