require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.410.0.tgz"
  sha256 "343c0fc243979d37b48c1fc5bf59858b2883a18f1ebda17f763a5de3c0ab2991"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6acd6d8d56b6ab20bdb0c10672d64d0f0b1b740d6c8a215504c9c3d55a3b3450"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fda4059f374e2b4e8f0adfe784da0fa7c471ea552ef725bd6e08c8425dab614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e52f81e2f6d2ecc77603ef2f47719f3d179f99834e676b2511f03af85c02361"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddb035dec20b890356823b43867388748d7ab2112dc41dc9bf7e1e6e957e9b64"
    sha256 cellar: :any_skip_relocation, ventura:        "94585833c3b252bb5b6a5e2cee2740ba78c58041c301cd52f830621ee99f4fce"
    sha256 cellar: :any_skip_relocation, monterey:       "20bfc54803c4db1e6ea099b726d0602c1bd97eff7824b8c90f7e2a8fea8f9e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64fef2e14bb142c483dee6db3941e1eec2ab246dbb77b321eb93739b320a80a8"
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