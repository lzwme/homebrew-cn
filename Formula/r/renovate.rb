class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.15.0.tgz"
  sha256 "5ae5708a549c113364fd6c2290c79d40845e68bf4495e532d8531b19e021b24b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8fed25fb7ea6663c39bb3d328938084174d7ac87c6bbbb79513b2a8cc1d51d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec0e11952deba277038c63a4ea473c29eda3debeeebee4682193b360ad1dd95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "813a254c81f563b36c34b81018b30bc2fdc5f1acb7e34ba0422af73fbdbb7e15"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca530a018f967dec17e0a4f8aea164b94b662310a172ea77fac703c8386654d8"
    sha256 cellar: :any_skip_relocation, ventura:       "c6d1e946acf1dd3a7e9bbc1d567fc7000ff00a1e2e4de2726116adfdd5addd0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d807fc8c0948dda908862b67b10218a82da9ddbd760449f2e375323f47bc308"
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