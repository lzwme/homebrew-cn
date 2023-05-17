require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.89.0.tgz"
  sha256 "67b5b3aadbae66ce436ba4c2551e2c299b1253b844b3e98e58cb4f4e3a15efc7"
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
    sha256                               arm64_ventura:  "7da93d8aeded6138a6129106e74f907a57b8b292720334cd7b32ff56c7f035fd"
    sha256                               arm64_monterey: "df8c3d3feb21b206c837af9e88449524faf29201d8a2ce5522e6098b4ee26678"
    sha256                               arm64_big_sur:  "82a75cb4a83db5ced61ac04964d6aad94def31e3741acbd32c84b8d523083760"
    sha256                               ventura:        "779f8ee26bf36359befe726edb9d5b80899d6efed35ecaca7ca3ace6804a78a5"
    sha256                               monterey:       "664f0ed475fc46383be63a3e1cdeefcbe3e4eb49386f8b7c9f286c703cfacb8e"
    sha256                               big_sur:        "86f491a767f0e38de5efd53d67d9ea820ed3e9fd6f42c6fd512686b6d32336ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128909f69892b9b200c3bc92813cc60da872cb931362b6fd27fa3bded8ea0655"
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