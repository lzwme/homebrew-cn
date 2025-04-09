class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.236.0.tgz"
  sha256 "e9a23fa7760fb1f062ebaa364aa91f9dc942df30cb6a7f97ef38d385e2cd5ca2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9eb162c4cfb17fdc4629270f16f8ed17a5d5bdce244190597feaa0369524dc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7f96f5d39a7984909314037622d36b0046e8428fb61934899b6e67408198628"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "878e0dc43735cb0551019b2f559d60aa99c5a5d3895601762bfbabed0cde1ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3708615de3f7e8b5ba3bbf1e71c883e7abafa8a44a486380099cba8311aa9af"
    sha256 cellar: :any_skip_relocation, ventura:       "8ff339f5a47cf9bc4e64b4954f3b6ecc39a773658f77c876bdb5a8e2e879379f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f64a0968cb2912d49d54dc2d69a133d4a11549380717c5294901c802e4cc0e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6511ff7a4da9d8c4f5214913d53af8849acb77988db1fff532dab8a72f3c2c"
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