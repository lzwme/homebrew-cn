require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.82.0.tgz"
  sha256 "5a66aa0c8ebe808bc43d7162f02454abba3d8ac4d7426093f160d81c7e35e90c"
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
    sha256                               arm64_ventura:  "57dc52213e3d4b64910e5d533366f118bb20246bea7783e3f682d49636637229"
    sha256                               arm64_monterey: "d08cc8a4ee0571c576fd3fc455ba789a9f93a4ca20a1e7b9c7d692f3fec9b4fb"
    sha256                               arm64_big_sur:  "1163756fb6d8a88b79a20ac377e625b0b6e63d8846944e3d4bf62430341f93b4"
    sha256                               ventura:        "ef0ff720d53d66657594dbd7edb480dcfde24f3a4256641a7d68c05a8b4c0016"
    sha256                               monterey:       "c3c6f5c94cec20e30949006748bf216033069d7c85d2d5bd87a515bd2d7fa710"
    sha256                               big_sur:        "65e337558a651e6f47e1ee535c6b7bb6912adb2132600edb8f44ff6cf3c0edfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "550a60e84958363d2760bfee0fb8071ff3395e020592a45e52713a5a63aa389a"
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