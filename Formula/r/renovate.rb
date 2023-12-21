require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.105.0.tgz"
  sha256 "0ff97be348a3c86d75b90d0db506507a1578d3726c442b416d97584e35733cc1"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76a4320de4fefa8b9a19097434f0414b958f0be05b3034da38f874bb43cae31d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87cd28a82f85b1dee22f6eb2a770a083dd1a46a18512230a736e27d0e15411ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be172536e6ae182075ffe1afca93227de88265be469b488c21b4328b46d88f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab493c99a1de3c0a718f8b826f14908c8db180a3d9f583ed52ab89e2d7d7dd2d"
    sha256 cellar: :any_skip_relocation, ventura:        "2affdaa81185d519e690ebbfa2737174a63ee3e4945311b8c6dd0322998d06b6"
    sha256 cellar: :any_skip_relocation, monterey:       "1387f1edd552578eda26b93a3a12ad3e86f8f445061a913ab00b2524a9752746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c620154733337c94694c6145e9a3730d80d8e65ddc69c871f16f12c1eaf263fe"
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