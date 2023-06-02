require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.108.0.tgz"
  sha256 "603ab8f1108b89b29c4887c7ad78138ca895cc78de521782f6274661bfef6cf6"
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
    sha256                               arm64_ventura:  "0566c3848a25c914cae2eaef6d72a7b793bb8c7dc3130089621f8c7836ea1a19"
    sha256                               arm64_monterey: "1d5e1a6650a323347078be746b6bd4265b950e136450bd406e0a5d7af6b881b5"
    sha256                               arm64_big_sur:  "787a88baf38c59da6797b7acb70e21b0247e7208e505224e8b0d24fd047c69b2"
    sha256                               ventura:        "14c837c6e6cc110cd50d593ef88905189be0dc2529d821e06712e57ba23ef318"
    sha256                               monterey:       "04002e812dd11e8c892b58f56cab876c21c435d9e42cdbafd613a0eba696e2ba"
    sha256                               big_sur:        "d8878fddfc74d49a99bff0f8a7479a2f9b9d477a9ea92cd518a3106854725457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3e696b74f4ffdca552af400f8c99767eecd14ecfafe5453247bad77d3eaae4"
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