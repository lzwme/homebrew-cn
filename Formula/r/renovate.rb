class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.106.0.tgz"
  sha256 "07183c8c85e1c8474806bb4b8cfecc0a923005efe3e08a7d16cbf36fce4549cb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881b6ee19953dc0baf2784a47e6bde0c85d798d0795c432693dbda77659e185a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f610fe554eacd7170cb5b9584d1c219c6e4f00d3f314df48d325370e68553239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df9bc183883a262cafebeba99f749d785e21d6e77dc28e9eb047e7a0db64383e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6fda3821febab2d250ba81e4d783435c54196d0714a5a0b62275cc151cb1983"
    sha256 cellar: :any_skip_relocation, ventura:       "f8f04f335ee397f233461e5632a9b3895a2c908e05b998b21da4827a1ad71808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "071a4a83976366d599776f4e560ed87225370db61d0d6361068c5b1979947392"
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