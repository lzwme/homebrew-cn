require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1275.0.tgz"
  sha256 "4540ac834f83427e738d8690b1b9c95f8dd42c8e7a509554ec8766d0888584e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e1a82a1d07c4f377d043c44cd0b3d4045e0104dadabefcd3fa85bac426a9b52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab779d81e79b72c0f2e9bbea56213f500c85aa0d7b4adc3ca0a8566b0dede37d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28af51dfa26abfc67ab8e1b897c25deb7148ddacb42debf160938555f8cc62c"
    sha256 cellar: :any_skip_relocation, sonoma:         "21dc9eead1dc5417dda17d0d2503fbd8cce76ca5894701c047bb548b975037da"
    sha256 cellar: :any_skip_relocation, ventura:        "19ecbca65e8a4a09a417547251c1d0aa3e7feb7f3271ac3cc1a25944cf7f72a1"
    sha256 cellar: :any_skip_relocation, monterey:       "e65db2b7443bc187d4c01faed5e1497fd087b6872e8e1ff9ef875fb50348fb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3fed457f156f6c6d6205d518f3831b846ac39ccda3fd577872ccc016c0db100"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end