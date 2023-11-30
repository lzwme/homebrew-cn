require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.76.0.tgz"
  sha256 "3a9794d27cbd4caee86f00ff7759d3158a8fb3879667c55c5c2ee8368843e66f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7f1b0914b776871742d9ba2bc8c0f6d6d9e7317743d50364b9d87c80e6eccfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9f7e4b941de4b927f38d43e5537b9e2a1dbe226d67914c2dcd6713b2b1b1440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "125d2434c76316c8bfece7b79a1e2f013a5aa10e34c3c703dab33a26484bebed"
    sha256 cellar: :any_skip_relocation, sonoma:         "b04520d74e03c53daf380c9464ba52e6b43a1f100eddc02e03dacd1c21352273"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7c9f94b2edba6ab06ca4f380691f4c3390b9a54cf567c3eaecedf416e60811"
    sha256 cellar: :any_skip_relocation, monterey:       "b81453d985fb1c8117b3b462de289ab6c5cfe19ab00b3d188f7657b42dd4ea4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd2ee0c6b2a77beadbdfe96440d2d7195653fc16a450f114dfd0f648cce2aa2"
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