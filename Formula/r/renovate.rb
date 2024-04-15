require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.295.0.tgz"
  sha256 "a588606799c9086067e3f6eb67249f1b21c34311995b58de02d9da191ce56861"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "edebe1d2e60b3bc833d64a899d42abdb79ef617149014ef6e3450a9ffa1c94e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f373792a4ac622bcaf02fc4a8147330ea0a6c0e77485e916815c329f604f16b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27bdc9799a869fa365a612d017418198c13bf7b91cde3aaa24d4333ec876e2d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "74d155a9baaf68456d866d515d1585e8bc0eb2b46ab5d1bf6cc32e40d00fa81c"
    sha256 cellar: :any_skip_relocation, ventura:        "a0442ddfb4c52b8b0f3eb231840b6f748c9a768e10130706480dd157a92bad37"
    sha256 cellar: :any_skip_relocation, monterey:       "c220632814d9f1e454208afd0ec71f3ffad6d58a90a5a1c612b585a322448524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "211d3ce0614200342482b7a30213db00a3c8246a2f2a51dc2e00528b2125008f"
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