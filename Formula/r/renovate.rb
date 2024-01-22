require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.141.0.tgz"
  sha256 "30ac11db50f37b4f3868d61204fea6592438461a18558d9760766cc15b3bf58f"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaebd2980fee0850059540ab03f5240f51f812c3e7dc35170c408d2e99380532"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dedfd37d6a78e4fd0bfeb140c57b928c6fe66314df9b91e5939c6c334960557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0fc20142d4c4be893466c3fb470c0cf03a1393e7e50cd5549d7996559ac13ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "791bd6abeafbad45c3c3bfbb255baac30b00c8367f2d7b0f488e9680abba71aa"
    sha256 cellar: :any_skip_relocation, ventura:        "1c522e55b572656731e22d114c4e74b8cca3b2fb94f374fe5d140faed6b6f555"
    sha256 cellar: :any_skip_relocation, monterey:       "26ca372231566c385c4f3c90e0dc38d4e442103b09247b6f690d9e0e2177f018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3516ac7e5874edd5345036cb6502fedfc0938f91340b0567bb478217031ae061"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end