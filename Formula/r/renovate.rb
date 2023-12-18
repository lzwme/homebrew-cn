require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.102.0.tgz"
  sha256 "f97fcdb351de51b1cc10da064759899bf191ab2c94f7df2ac742dbf86add93c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b217d7587bbd5ff30d3dea1b325624701b0f875da6be2057d040b8a2bd9a0c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "491297116ee25ea8189a67da441130e912498c7b28080f2f4de2ad7cda249661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f720d0e01bbd6bdfa00cca196de52e7d90e05ffd55644af385770e7c7a736402"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bdd5edb506d65e07825ed2ea8d44d4d6a0fbc24b9f83100680bb23b6b21a146"
    sha256 cellar: :any_skip_relocation, ventura:        "74b57c7923c9da0cfac0203c7a777a5e1f269caf8d47320780ad8745edfe7f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9eb9635060d58f403c88a80d8cd03699ae39b8fbeaefd3b2f2fab78f404022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "487e67aeb10892b06f1957c6221020ea366d5d503409b51b9f01e79b3d6918ea"
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