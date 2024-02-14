require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.187.0.tgz"
  sha256 "109fd5f08117ea4a1ffab54f01281eeab33f44589b3c14ec327a4106f3283792"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f91b9cd99776ae30e8ebdf83f6e29c1401d56136b52b9134f67679ad8a782f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2ba2e8c0934901eb2c4604be456a7bf3d04c8427349fb5083548d5da363ac7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fabcc48159e2aab2c89314b8c84d11d6f7a2786616d165f3fe807b28dc81bf5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d66b40e301dc3c85019bdca8e18fa87be024413b2fdd9d68374b9bc85dadedf4"
    sha256 cellar: :any_skip_relocation, ventura:        "3f9da22d397cdd628d6267c03d4a236d42cbf12eef306ebb03b430bd2876b9ee"
    sha256 cellar: :any_skip_relocation, monterey:       "f27af35ee201af4bc10ac68020f2fe46b575f251963ea017aa7dd83dc9c24fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee8a3008a04d05ee8eb27b7dd97ab746e31c171f2ab1df8bdff7a76bec48a86"
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