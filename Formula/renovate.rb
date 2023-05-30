require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.105.0.tgz"
  sha256 "3ed868680bc51626e908ed4f94e7b75cadf6a79371ff8b241b68ab493774837b"
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
    sha256                               arm64_ventura:  "dba76db8788ca39edd215dcb1a0bd335faa87efec004b662840ccf9c37f69638"
    sha256                               arm64_monterey: "ba4b61c75a3779b2d68e46c92d60b4e291ad1b43b6808cd59a7385a2a571d9d6"
    sha256                               arm64_big_sur:  "414ba493199c99bea7f6aaf9d8659e5d1f8e6b71d3e4968cc46b24e6b80b46c8"
    sha256                               ventura:        "0d0453a2e6be4b021ae472cc52a6ff3a3ade8193d3d0d6a4676dcfe3a0687d49"
    sha256                               monterey:       "19e1d13e3c55367c02a8f76a3f29a9a917c4dbb06ba7d4ac9e6b2bdc0810921a"
    sha256                               big_sur:        "58271afced2c30dc5832f50fa11b92c9386a22d63c07ef30e69f5cae5f50aea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345f74b4a78d90315604e52998e237c48dd1e85e45852733f00911688ae70438"
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