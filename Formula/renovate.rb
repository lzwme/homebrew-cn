require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.102.0.tgz"
  sha256 "ae9e38f17098c4f4220476372325a34360e20e71b3196ef781a5ffbc64e94783"
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
    sha256                               arm64_ventura:  "18d5d37b2c63b0466c6a2df389bfee1e550eb1e340c303de4903a13d1cafce2a"
    sha256                               arm64_monterey: "e359d031f97b27de6012df8f7b2a1512af0944ef6a4244ab852310b0c157b6aa"
    sha256                               arm64_big_sur:  "110f2c9acdf045cb114167e0557bf63fe276c2e64c48c4807a1e9f59505188f9"
    sha256                               ventura:        "5dc3571c256e552f6bd7b4f3f9f2b19c7a64a1858c2663b760cb43c142db578b"
    sha256                               monterey:       "c137a49228163d9750097aefde739b8ccaf8e6cd9074979bf61eff3fe7e74b33"
    sha256                               big_sur:        "d27fdef7f303f3561d839a6eb13dedb5b0bab2633785b9b57d3ba8781847d40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be1e5af65b0ac6d3f40f164345717cdf7a9855eb85d628f1eee85dde470fa93b"
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