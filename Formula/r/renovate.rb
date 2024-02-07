require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.174.0.tgz"
  sha256 "ef67fcbe6ddf2a473616608d0037174f191321d3d1bd0d10da308a13bfa7f708"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2acca547850393c2c435fa905d549ec21be0a228e281cd46f39a21c910ed6bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f99532a3feec3a2bff3db4f492a48517a1de78153104d634caee8515f14388ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "747b4359a14dc84091d448c60224e477b52af8171bb4805c09901e9fbc3314d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "91c1405e863a6d97949342a2c053ee028e8a8c3bb2187ababd2de06e05d1c78a"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb7ae409dfad1febd38a3c8f31c5f0f083b289623289103b3de4ec12f211795"
    sha256 cellar: :any_skip_relocation, monterey:       "08d901aed247090338895c94ef20d3f63424d4d702977d1c905eb2b4967a6460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a61411df4d238a0f095c420e63675c1063189306538f5c30a81ba2c2640f35"
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