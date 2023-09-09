require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.88.0.tgz"
  sha256 "21800b9d86c82cef024e08ad4d8496d2190df3efc93ad288e56f1acd6d885cd4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9708ab8ba14bf035eab6b45a27b934d9a4686a74b92bf850c40c7096f52c7d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a0d362db20fc3ced5712a699c40124417e7b114ce87b60abdf9e1d67db16461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57b5a09034d8a08354f12022ed9601e0eda68eefd6c44b5d1115d15f343b5d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "721661e2bcafe0191e3bd1261f643754fe8a116cc3c79120407f2d400a470eb0"
    sha256 cellar: :any_skip_relocation, monterey:       "323dab252259f533232c38ebefd95463b1d511470d851df5f9bac4dc0eeb748c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3c028f25b3f7b2f864b71f3cff6c29a6f30cfefd860a721651776d60cc7e010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c7d573ca5478c41e9f91dac536d497e7207255d2df6ef0eead6a3f9d881a839"
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