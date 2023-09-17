require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.96.0.tgz"
  sha256 "f9f3f12f96f89884374ff3bbe1d36834e4434cec76d8f3a602cdafebd5267813"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b7d6d0150108f3f28b5f4365247c57049b00c0d0cbc92a0febb2f6743be333d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4731458a93e2c6f7d5ca31ed5b0f5cf0448e57f5f463a362beadf713de6cfe7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54c69ee357a711802f4cf218b3a9b2f4327179da90d6d3ab067b5884e4f4f834"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a2610eda643d3d98648ebf5714ec11a3f37da03c355aa19fb06043b06c56ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c5e27f40a9b958087a7185bd5e8adf53dd39b8b99f8867547978b89dd6313f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6de5cd2cd34b1b178b8d759319ea5e2083cc332e90a7d57b422607cdfb69f2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c18ab78cce6cc71595fd77aec6ffdbb64a03cabca85a576dd0da407fd20068"
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