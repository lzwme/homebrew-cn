require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.11.0.tgz"
  sha256 "37a9eb986d154557769d2bf48227631e4ea92e83bb4d90bc931e9ffbc67509cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59dce894022150214a593073342015a0304c5cc4fda189ac9f9814cc9aadaa52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b825a40026db9858fcb5b5c841b24c6aaa89438242dc3c713f4a6cbcc9f06b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59462b8047ba7276f6fa827375cb159e6599c30fd4fe919bdf1db40917fa6dc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a390144ae58d4947eb4c4d64031a891d95001eafbad12616188eac2da3af95a9"
    sha256 cellar: :any_skip_relocation, ventura:        "b5134f8bafc96b70349becc88cf152a4283eec928a6b0f3b5b20d3394cb25d3f"
    sha256 cellar: :any_skip_relocation, monterey:       "e056b25dff13d47a491efb83ca89385fa4d737dff2e50727d12dddbaaf04bef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb1f1a97ae66c84bd7a84d5e0b276d0097a4fbb9793b1cfc3b802b3cca5ef67"
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