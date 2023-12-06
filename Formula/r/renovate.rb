require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.87.0.tgz"
  sha256 "540a36ba47cf46ad54233127a7b0300132ee39bae66e4dcfb050a8933dc095b2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecd707c6774a0e38cfca5eeedc8a1b02a5390c05ae1f5010ebf8047d03892b57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bfa92cb7c6583aa8d9ab64f74e6a7ea52ded2ec4575144bd5fa0792bb30175d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4af5a3987d149be1e377613f9f54eca591f561fb4d33af803c654a83b4954aac"
    sha256 cellar: :any_skip_relocation, sonoma:         "090b6660b3902f2abf82c5b7216d6c5f397a464163c88b7b4968374583cae1c2"
    sha256 cellar: :any_skip_relocation, ventura:        "1c83be9906f1cbfe2508df7c9972a6a8ec6f8a1fe06c962a2db27b849ff91cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "64875c84190f360d4c3f2ffbb32c2a8a2c58e5a3b68c4c0c73757fc2c6e31f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea9260cd00b849caae9508992beb6e6cf82e13e84d338c176d78316ef842615"
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