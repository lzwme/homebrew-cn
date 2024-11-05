class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.0.0.tgz"
  sha256 "3832697fddaea4c86c60129c06d1011afb52a2365b46ba3e3802108fc8603c43"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7a05dfb892e75a1b36f6f2c2909ddc102f7d815d50a6cf145a976a8c0618810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4f3360720f1e8c9ac788573028ac5e59471c676ca8c9100eb50e3798f0e7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "17dd7f116f043428618ab1cfba6a25a2d9afbffe1f874b0f335d41ce514d286e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e4341659a2526746a2f724549af7c257d084a611edb7e7a07b6ad8e9edad63"
    sha256 cellar: :any_skip_relocation, ventura:       "650785806cbe98179b8a712dee75fb1aa41642a6d5b8258fc8da496a93a8b235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c43d5de0f5be2abcd9988b2369376137cc8a07b6a769e5e2d7beec2747744e"
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