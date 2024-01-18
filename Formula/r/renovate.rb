require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.139.0.tgz"
  sha256 "43fbcf9275e5a4a3630b8bbd868b3d5d4dc9fff15e28d07b18bb32d9bfbc61ef"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc183d00f73ff379f110fd8c58937db16b7b714b4041d83e838aa48a0a09edc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8e0baa7ce3f1c795f3b92ab91783d461fc6c2f27218ab69b61ce7a89161c9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1373acabadd47a791dfd21272666889519eb6fed65c2390379bb29f30d3038e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae7d13c712bdde59a99a6171a96f844c4e26e5dcfcdd47ae16a7ae38e536f664"
    sha256 cellar: :any_skip_relocation, ventura:        "05a3cfd7fd5572fa79f4df7f054a4e5400091d637b43dbb6e600dc0929abe63a"
    sha256 cellar: :any_skip_relocation, monterey:       "1978181a4f0d5c7c173eece5a9258c78a1258aba0f956a2ec374bbfa133561aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1a7ecb3b272eff3fb4ae452548dfde4ec3cbb7ca204d53fabd1c28832f4f76"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end