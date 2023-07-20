require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.14.0.tgz"
  sha256 "4108489e6e655c80a2ddb7611984dd2192a454b51a3cd94e12ce611246f3c5ab"
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
    sha256                               arm64_ventura:  "5031f11f9e56807eba27ef66d884f6c95f16cda59cd7361b2fad79d125678339"
    sha256                               arm64_monterey: "01cdac7422f590833d038a862bdb23dec28f435a7f026f5a9bbfe6bb6dee3d43"
    sha256                               arm64_big_sur:  "15622362a2ff6a3e171175e41b6a9f42b712e71dcfe29231c5354f49de6a6a9b"
    sha256 cellar: :any_skip_relocation, ventura:        "37a688f36e14c337e011f10b3171063dbd28864e999285e422bf51bdf438addf"
    sha256 cellar: :any_skip_relocation, monterey:       "ae26eb3a433f842e56face239ffbf190aec8e5871911765570931bbe867a6dde"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3e2a98841d2af66116afc2ab21bbcc3020ad1b1850eebc5c307641740fe334b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c11b1f2cc7b20bbf7d15129b591253242d987ba212fde9e59c2ecda5cf39f510"
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