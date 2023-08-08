require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.35.0.tgz"
  sha256 "278ae1c899af16128d459ec90f6b92062c248ba493f1c5bab99127a1252c0358"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "040263c2b15b2ddff330ce0a4e656fa2af9cf27b6c002ab345f17fe5c951fb50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ee9d965c1377bcc6ef8a0c5d0b7917dff990292e5c06a19560c1eaca5af0a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acf20e61742d9d9c984da93acd72bed0644944b51cb079f1451a8bf94a315e17"
    sha256 cellar: :any_skip_relocation, ventura:        "a41d0555ea2db9a3521ecf9ee5aa5f533a23fb0337d55f694542d8fc1cc12de3"
    sha256 cellar: :any_skip_relocation, monterey:       "9f1526d863d9f26c438fc614fc04b25c617b36151741f814848ca4f5881eedc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7866be21af978ba9bd4eabf6e1a7a4a0fa3cfb4d26c63eebe83aaf35946f528c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a34101a414a8ccbdac8a6cceb4bf18ab7125e1a8fd7d6ba5804485f0db1cf7"
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