class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.32.0.tgz"
  sha256 "145a0a4cf04173318b1361d52a70d62584ed83a7c9047a9e5fb5757c7ad7e058"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3d228a5c2baffe8c5ff8d9a3f712cb1fdf0fdb6ea1557824387f2f5f7b8b34d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c63de213cbfd44e1851c237123049dfd0677496bdf22936778f152d71536cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38b76a9bb502e30afc596eaea8be7be38ad94f30d441015e1a5b94efd71a67b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2e1031f7563abcf07a5d9275a19ae3d40aa1d9fd287dc0bcf7152baa0108823"
    sha256 cellar: :any_skip_relocation, ventura:        "fc5031d5f52698cdd86f4237404800b183e6268aee4555bd789c3e3367d0e1bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b560d58e8416fbc3ceb5c921f4ca67f7e73a883ceb7c87144f3d74e3beebf33c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec65ffa9c60bf5c0b4a6c391c1da7083d997c7f78f29e9bdad2b649413d22acd"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end