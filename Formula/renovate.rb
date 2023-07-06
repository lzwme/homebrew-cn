require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.1.0.tgz"
  sha256 "854cf3bd75c0faeb5d7ad49599749600fd095eda4f5f190a9add6841d348c05f"
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
    sha256                               arm64_ventura:  "ed0e809f00c32ee83edd5045260f46ee439ce03b843542b802d2a4546d712060"
    sha256                               arm64_monterey: "7763b2b9cce4ea24c604028b1279324a78c24d67f19d3b7d6e50af9b7fb14372"
    sha256                               arm64_big_sur:  "92c74582317bd1328e7a3920f75f9c72b4d2f968ea0a47cdeafb955bd9bb8ed4"
    sha256 cellar: :any_skip_relocation, ventura:        "a57d1fe316c7cf41e4d3bf3af7a90d74b936df092ed8b68ed8fa9845104db736"
    sha256 cellar: :any_skip_relocation, monterey:       "d8dcb28ab21f694b06c3bfd238ca7198472593d8dc5b8fbca3e84fc30dad0640"
    sha256 cellar: :any_skip_relocation, big_sur:        "0df5f9bea3e82e9c4f2b233e26e664fc30cce535dedff2597ddf65da83568523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c53bc020f3a1506c218e1f3de27e98110c3a531467d447c78161e45058ab13"
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