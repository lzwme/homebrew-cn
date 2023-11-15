require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.59.0.tgz"
  sha256 "a3913ce339ec15c1e940042e7dc64ef22d9746cff61f4e7ec23d4fc69d6f9399"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe1147eea77b42af20050ea87bf609d4f9c76af8cc3d116056cbdf5a8c6cf9e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d593f815011e538fa9e6d07a64626b3e06412aa3ec3a6667b3d6d8502c72093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282c9a6f357905343b01d9a2b4ec7389367043859b015966b2f68255af669b11"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9bd4d229d7c6da427585ca34ad62fb0717d555349d70c636c8aab185774ef6e"
    sha256 cellar: :any_skip_relocation, ventura:        "9176c3e9fd6247e634149ac55d45c859ff6eb99200efbff6357a7566568dc82b"
    sha256 cellar: :any_skip_relocation, monterey:       "c151361b7a44c46689cd00db14e4a2f9f5a97c1e1bc764d4871def8057b2c7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "145de3e42165fe702d798dc7f14c53a2561c384f0bd048ecfa74bcc709b2b46e"
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