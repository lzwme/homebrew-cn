require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.152.0.tgz"
  sha256 "906ed2d3a17c9933b9e8cf8362d75dae6e11694be4219c3e791842e59be66547"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b520c5cb11da601131bc8582fb5c80accbaa7d2264bd96ac93d351e2c2b153f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4425937574e679f1d68ddbaf939f98bbcfe2b2fab2dbd9172b2a33d1881a6a44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e73ccf8f8ef80d85aa0aea1a79731a2576fbaee70c3e702ed62ca6a3699ed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "90f11a1c617f4ffcf704aaa92c5e9448ba9c21958cf275a480032700aa76bc3b"
    sha256 cellar: :any_skip_relocation, ventura:        "3f487761a5a6cd69b54e71194276e7ab8aa8c6347944255f77ea95d592652493"
    sha256 cellar: :any_skip_relocation, monterey:       "e0aa1b621df31777447d524758a432bfd03e715d1f80d7fd2edcc722fa0a7bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8defff4a33d1b5c92ed6c97e32cbb1f246ff9ad03a94694154737ba3a79ba8dd"
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