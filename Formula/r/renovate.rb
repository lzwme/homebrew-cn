require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.390.0.tgz"
  sha256 "f8c2783a2dc49ba25ade0a50d2d548de14285948b3db734130336813e62b3ffd"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41fc1a2166050d13a96d29f867977c83dfaa7699e5690c7d736912fc84ef4c28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9b7706c820e5dc3cff76e49a0c168b75aaf4195118693d9ff87316457a9c18d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f74a86f994762f5b487df6d728fa3849e98391f056a8a56ad05bad188c72915"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a1e5fb7e169344684b129c86b77cfe80a275e87cec879c248b157165eed9e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "0d2e0c406931e65cb6d3851267a8bc2a699ba77fe0a0f0329cdba1f852cdd3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "1f48069fdbb40b1bdc19e60682174b33b49fdd96a8192d43ebd76efd07b9f01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f2f4632d3abea16b99e8c54edc0e11441c001a6cc563c1c3bcbdaef6e351514"
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