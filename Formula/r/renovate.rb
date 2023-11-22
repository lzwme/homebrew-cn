require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.64.0.tgz"
  sha256 "34feebd766ef66b7bfa8af721f19efbdd414e4cdc5d9b62f047d4dd94485721d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f13663872e547fb51afef1a277d42b6ed6bd2a7923caa60b72a8dbf3ae1e615a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0b0329bcaed4fd4ed2af8b1fd7283d79ae548e15f67534b29c6571b4911c968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebb6ac4cc659f15cd3ac9c5cfb78e8fae1b51d126d209e412d3b9115dbf72c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8018d5eb2a430b856c8bde77b8863a2069c2d99f1d1d0c691e9b879c0c31c25"
    sha256 cellar: :any_skip_relocation, ventura:        "c7241f9b929ab516dab9b01af62995278b1fc37d9e4e3c95cf1da5cd82ba9351"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2718da0cd572be9ff3d93768ee08c80872e81fd105d029a611c04f9de322cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb101c3428e1f37d2668793ed1f59d92860d95c4aac68db5edc8c05085b8a85"
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