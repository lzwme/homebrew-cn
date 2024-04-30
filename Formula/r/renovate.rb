require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.329.0.tgz"
  sha256 "855887762a458f380ca62188abe091c553093a6e562d720c72aca150c14d568a"
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
    sha256                               arm64_sonoma:   "bd85d57fc1d0eae1ee61d92edffd1fb43fc3d12bf7821265906d271ce292c18c"
    sha256                               arm64_ventura:  "1b382b36732e335a9a6048506d0795724585d5c4844a01ec8e006adbdb8e52f2"
    sha256                               arm64_monterey: "b4b7ce9019180246b3d4a40841d94811a3837967a87deaf6308815683f8b9566"
    sha256                               sonoma:         "3102c79aada38297679f94dca5c1c619cb3099242009307ec4824286e29a26a0"
    sha256                               ventura:        "360f1c5c483a0d2943648e23c1b52b3d571d282d5aa059433abcaa040d223ced"
    sha256                               monterey:       "329aeed819f926abf3fb1088594f1e5f0e75c65f7e47c7b3f3f8753a577a4f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a14d8f64d40f542a979a2a2f7d816984b694449c6ed312b62c885c01e56bbc9a"
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