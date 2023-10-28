require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.34.0.tgz"
  sha256 "6c60f5f5b7fc6a5e5ed0475b38bbc48ff56e224a4932d44d4d68715a36504200"
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
    sha256                               arm64_sonoma:   "b561eb312f7e476822f2182e6c45b18fdae1ace15a14e73ab993f6724b8e4c33"
    sha256                               arm64_ventura:  "56aed8f83c5b02069e377a72bbce602e8fba97ab6b2c0ce38694c0a4707f3ec7"
    sha256                               arm64_monterey: "254cd0a12cb18bfd96c5475b9d83cad85b347f84e783f36d5ed56f46c5babd4c"
    sha256                               sonoma:         "114803adc9d0319f35fe64d0a5b02979521051e1c1c4de6ab9e8cfdade3d5da1"
    sha256                               ventura:        "b084be40a616ea35141e3be032a0850dfa76042acff65699367571b87370b7e4"
    sha256                               monterey:       "8f6e6ec9f7aa17fd146a372a97da9abf126098e1debadabda85255493e45a309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21375b8f43beb8cf45244226ba53bd742b20cce478eba790a4226f39fa946854"
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