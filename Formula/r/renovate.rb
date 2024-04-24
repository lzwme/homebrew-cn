require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.319.0.tgz"
  sha256 "601ac7436e62f11e0fa8113c9ea0381cd96bc96c9a14cba027921d7fd87b0323"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e93ef7f6225f81c0bc5c00133ccd81219d123b7bb1fe4b492127d64a8e9d3339"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f021458cd3fed839e11d3a8214dceef6afbaed6eab701cabcba185a17fc0e7cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9bfa78a93687f5fa9e13cafb23258b9eacfd56ddd792d43b88eb1fdb588b661"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb3a7c7d2d7d02351a45e55df29cf98884a0da72f50913de6c8b748cb8b1330a"
    sha256 cellar: :any_skip_relocation, ventura:        "d31d2ebe33ad24514af575108452bb6f47aa14e49ef893533ce5b6d05f408299"
    sha256 cellar: :any_skip_relocation, monterey:       "b4043f3047bc9ca2f674e0b3d12a671dc22d25f2f300b574fb1e74631fe6dbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b14e8cc8a6b734d012768951900b4199c4b7a2e365c6c68430434cd04c50c588"
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