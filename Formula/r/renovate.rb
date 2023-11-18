require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.61.0.tgz"
  sha256 "afe53064b8cee09421852931baa988510ecc4905ee4abc59943bb61e7f24bb3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebabbfb3b824d35aa015cb603e1b7c274b33351be059c913b2a71351668341c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962aa97b0db8658243d3b0777583fbaa06b61f0b8a16a70358f98299153e53bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70c50bd9195edfe022de7ec55caf7a950e4dbaada5743270cbd0d779407a76a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "43c26842fd5308842583c6407662e1320d8fcaf8cf1f150a522689114a60e775"
    sha256 cellar: :any_skip_relocation, ventura:        "7381b8effac746d01fed24e9f423a2a7751a2a685f9bf4ced8d9139091286438"
    sha256 cellar: :any_skip_relocation, monterey:       "b54639b3e690bf357c4707fd434769daf3ff39aa4cc0379cf58dd9b6946475c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ab70c2f69edae9dd69ba2a3cac12c2770b5956e0606d15b6a1ce70fa17e1d3"
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