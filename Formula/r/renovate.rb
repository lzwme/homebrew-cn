require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.28.0.tgz"
  sha256 "ca3da3a9cc6ee69ab1da1e180bef275372ddb39c3e4cf429ae926334c510a37a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d6bc610be7e9f15a2ea927f695c178183cbca4a364d1b36ac5c31e0d93c78be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f48dc460e8369a2205fdd29f9807c3d9799a12120ae0d6527b85b7920f5b7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52773b73ab6191c81205b1d023d02c0cb5266c2d6d9cd96ac86260b55e0c2ca2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e27eb2c871b9fa73704e1f7d82800968d95c9c577918176329e16de7f88f28ee"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7194b253a3e58a69872929df3c9ecbf8b11f40d20e1b578a02d1bae5142079"
    sha256 cellar: :any_skip_relocation, monterey:       "7ecc82d6216042417ed09eab0ca2f7c2a14ab394bc65e19152238c745740c01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b3a9f09543245c78ba0ce795560b9378e534e92ca340c00790378da554affa"
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