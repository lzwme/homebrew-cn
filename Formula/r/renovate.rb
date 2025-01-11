class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.103.0.tgz"
  sha256 "51a63f45a8d1a1decac9c7c946519cad6c6b0ba3f47b8b2a2962cd3e7c24f33e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e60b18327321ae006d99eb53b7a38dbb070d80e76a7cd1ab05a3ab800550391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de39dbb6dfca1193fd5fb409efafbeec0ed60cb44476b3e3c98ef2743f862831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "707b444524e92a87991fe3ca7916ffd91023acb1477a61b4fef80bc8b8d511d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5184b94a8f5840e7e5600b0dbda333a0a20caaee4de8268f768c67af6e4fab94"
    sha256 cellar: :any_skip_relocation, ventura:       "e3f62f1934e8b310d8f3306ffde79de73524aad6473427e0c186aab35b9f6010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c265171d73e6d32743281396bee4c85d8491f904e731f7c1054a335762a8df4"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end