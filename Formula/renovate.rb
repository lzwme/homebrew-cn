require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.18.1.tgz"
  sha256 "e048c9c8762288eddb328d81b8dfdb87f73a13109d8d7cb162bf97c68fd1024c"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "46fb92d2aee7cb801e88c1a0aebd02675e0fd7b70188051399516c4eabf1b256"
    sha256                               arm64_monterey: "c1a571d8eee4e3f21f512adf1400c3553fc51ea8d992d46b063f8679f6ab3109"
    sha256                               arm64_big_sur:  "887bc2bd828ac215ab6582c2e94b988874c94a2f7149dc0a4c66090d8e65951b"
    sha256 cellar: :any_skip_relocation, ventura:        "78e3c257041944071de310454805f0929e62f824c5fc6a5dc7dad1f871e30d0e"
    sha256 cellar: :any_skip_relocation, monterey:       "2b00123ba29d6d98985ce3657950ab8f420085e7a675833315790d904922f495"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f43796681770c4583d5ce9e32b90f020cd9d96e34c783e1ae5e79411ee8f2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf73a6eb5c4937f765890441627c0544315ce64f4f0a0b97e77a1e5e30a38fc"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end