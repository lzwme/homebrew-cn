require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.13.0.tgz"
  sha256 "0e7d0305801a95c6a999cb997bd4fd153bcca9448424ed824deeff957cea7247"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2abab7bde7a64ef418b7c70080a43cbc63df72389db8c1dbb9d72a87a8f8029f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fa9c34e1d409f608b84f599a0879486608649e209ac983bf78f586bdc0d0130"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78bdb77bcc38e7e0166c22a257c838d11b3968ef612b6ba437b3e918bed299d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "773d78627c85867b0055ee22d555e56d3abbd8fa598e1f1a898fc8788c448895"
    sha256 cellar: :any_skip_relocation, ventura:        "a767801c5c0616c428059d6d39d2a6a15e1fcc90e676da61f18bcafcd744fe14"
    sha256 cellar: :any_skip_relocation, monterey:       "adb4908b02f315348e90416f3478f20ea8a1b21e3ce52a7a1daa4ecb7c96cba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc44601a73b2030d77f8db21d8c99ac400ae5a32b26083cd536f27cc5ad630ad"
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