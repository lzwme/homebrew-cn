require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.153.0.tgz"
  sha256 "e2da34d2097fc01b01ba1b96cb851cd5c688075f58d6b74d282546d7bd2e9380"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83f49cffee175179fb38a31ee5e47629a2d32029c35960be7d7ea42fe80afb08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0d17ad5601d688d07e49ffcd4bbfbf35f3a4b167ceca4d0f2d9a9b58695aaf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5753eb36e36e5800f497e40677baa9223244a2e0a05fcfbac352ca5db2f78c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "10ef2f57488095455571bcf558610a22eb2368429819b998d28f64906a46a840"
    sha256 cellar: :any_skip_relocation, ventura:        "b1ceabfe4783d8e58179849a62ea7e49db30f144399ff8aa7ee6fa4e29b3052b"
    sha256 cellar: :any_skip_relocation, monterey:       "945ae569c22840fa3e41b7f5d9f3ae3b0a4be0328b132a577cd937b2b41f1d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "816f5b8e46368fbd3bde5a43bc6f64044c59fcc39d76e2a71072f7a81bd8881a"
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