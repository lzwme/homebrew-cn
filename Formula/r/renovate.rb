require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.51.0.tgz"
  sha256 "357b6779fe83e15a545e4da5936d3998921770fc8d6c9e4908effd8523139b74"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc384da55987d395fcdee22ddaca2df6a47adf86c306d4bf8d2ddddab7edc2d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba447a84f80976b0d45f6d7bcc33cda6fe9bc359e3446168284da85014ba7d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "239a833cff7f349d6f08b524bca91053a6a3751d9ba473c72284f94d4c3efd20"
    sha256 cellar: :any_skip_relocation, ventura:        "1fbb3f0d98cbaea194f068421161cb97cdaf8c49a466d38a75d0ad7219caa10e"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4172631f2bc7106d7046ffc6b212f3e276dd720c4b2087183b47762f70a022"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4255182a76c401031e25d54aa85fb0d6b790007eef1caa5899ee9b0107c411c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b123b622e1f4a4d3ed2f42eceb1e3c2cfb794b454c086f696e3632ea77d0a1"
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