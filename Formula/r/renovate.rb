require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.64.0.tgz"
  sha256 "fd30401cff354ee01566e51dd1eb462f9338dec1771e4b9ccdf89fde5bcbf6de"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a341aca9b68a54896602299708b7df09129385abf43d54da615faa33f08b9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "154b0685f18dc3e9641ac03bf7e6ff94fee65340306f06440dd2a9431884d992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1437b79063eaa61662460038a4f14f65a71643d38931d955d09c3ce1696a3c75"
    sha256 cellar: :any_skip_relocation, ventura:        "1b6c3e62fb698b7d5615ea2f7da6b3138d26eed2dd1ee0aa2b6611f83609bee8"
    sha256 cellar: :any_skip_relocation, monterey:       "ce92f26e1c89bfa8637380231ea8ce24c05c7f3b46ddeaf5ea2f991b4604f75c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c8fb9e6976b8eca020d6e51e5dd6479f7752ef1dfe77f83a2f87f46d0962f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fa2b7ce8c4fedc49733ccc00144c9951b4849e856f7040a217692ad56707b2"
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