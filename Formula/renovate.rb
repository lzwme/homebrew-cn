require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.125.0.tgz"
  sha256 "e77dcb563df8becd44f39761f9e74e0dae4c3811f2bfe5c38504200a87a77cc1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79d80fb0e8effb8e1719704e8779b891db76651800de3801b2766205ff137aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9496299ec80d056ae610e2db8b0f1c33508ac483237c8c120aef3a0c746095d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a79c7b1ca1960cb3108f901dafe580b628573e35b6d41c2e669555f34d37a18"
    sha256 cellar: :any_skip_relocation, ventura:        "1e1a3d0d2bbe2d7891802e28b02af8675465b8e5922a5e8dadd6c421833c30ce"
    sha256 cellar: :any_skip_relocation, monterey:       "76b45ed4e7ed1938b96656addeba090985a385f66d17722b510c862ab740a64b"
    sha256 cellar: :any_skip_relocation, big_sur:        "522f7c5f3e8576c9753ff0e1ba6714be22e14a06b8ec463a430036eb373fdf23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f26732777a0def3934c04b350530cbaa274462541905defe1cdb26c655809e4"
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