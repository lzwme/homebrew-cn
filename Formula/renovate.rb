require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.26.0.tgz"
  sha256 "3ec20641343afa63259fdbf67e1dfd2416fc0a3fe040b3a1b162335d8280ee8b"
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
    sha256                               arm64_ventura:  "3f8be9ca9c9f223fb5a5b02992eb5c3d3b94d75bae2ecf7009efeed9c7182ec3"
    sha256                               arm64_monterey: "6424e1cc0a93eac7b73389a6912f111ef3725f0efd019509bfa8ece26ca12604"
    sha256                               arm64_big_sur:  "7d641d2467661014bf0e4fbac2e8a2f4bc4c12b2c432ed642a871b5eea8971e9"
    sha256 cellar: :any_skip_relocation, ventura:        "8ac414e152871daacf44feb645f44a0725a476ad83609411dc1fe194a057286f"
    sha256 cellar: :any_skip_relocation, monterey:       "055e412a599ce393bb0dfb36f3a61edecc0f2e8009eeca4522248f597604d5d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1556fd98bf1c62a064d80ac5178cbc261a6cf1526a050d33c72ae98c04aea302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b881d04a47de3b264c2be3a7775cd6a52e6dedb823b85f33448cda8fcc11d4ba"
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