require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.36.0.tgz"
  sha256 "eb4cfaa4004ddfb03af882fb4095062e884e0cec5c532c5e11d317de2a3c6505"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "069c6eafb1dc042c1bac0c2c9d11d4c3bbace205951705ef69b97a27fc72e9e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf15997bad34d9175fb93ba9d7186b8a838fc8f7b312fa605e536c5a5514651b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1767a8f1c33b7b3c56974d5c432528f64a0311131ef7f2c81c395befa2e657c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb87e510f3d55c1488eda0800ff6cb74e88410311d6fe17d43e7fa9cd042f895"
    sha256 cellar: :any_skip_relocation, ventura:        "0b77f35e245ec8aedb0c77c3eaf7fb295101b301a2cc88763175dbfb62fb3d48"
    sha256 cellar: :any_skip_relocation, monterey:       "69bb9bce841724913ca2b5c1af1eeeddfdf9b4d29f059b59ad60be35787aeefd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f872eae6ba6d5cc8bdc362f36a80ba818662a20bdb0dddd08720e28d4d314b43"
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