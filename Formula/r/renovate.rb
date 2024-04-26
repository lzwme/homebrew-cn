require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.323.0.tgz"
  sha256 "97786ac423c9e2ded83366feda6399fb29de99c7cdf6d56ab32f3ca3fa884024"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e46ddc1896e63b1c60b74520e2c1d4ea285cd653c3e5d32589e141b9c11f8c64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce9f8926b7b0781638d295fb792c08408f098e916e617aa73463f5e36cf86e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a07fd44afd8736b44887f71d91f164a1c395bf0ef5d3091c85353de991e2c430"
    sha256 cellar: :any_skip_relocation, sonoma:         "73c6927ed924aeb771d9f3f82d18ef8a2fb339cf08e1efd47d9876dc1d143e91"
    sha256 cellar: :any_skip_relocation, ventura:        "f536740ce1313205b58ab22a98d1211631f117f498012027f21a7f97366f9962"
    sha256 cellar: :any_skip_relocation, monterey:       "fb05b7b6dd18de7d99a4c415f4d971eab5a180369afdd73db746d8492d2d2bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79f8301edc855bdb4b70b822e79248c54768b4078c7ed7dc22f5626f0688b1e1"
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