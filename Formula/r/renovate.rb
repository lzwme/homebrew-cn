require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.110.0.tgz"
  sha256 "328502879ee74eaf733e1f795dc7b23c01ffc74adb73c608a16519fc23ba15b1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ba577b153db7b2a320789adae2a0a7063e78afa5fbdde016be885688432516b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d002eb4d6274060ddbe46522c4ea0b328bd00fdc91caf421586c12cbaf0b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595ec27836b2029130806e584a76749af4f34cab9a9a9a0ba33c3b92eb098b53"
    sha256 cellar: :any_skip_relocation, sonoma:         "c38ba1e68725f2d873c63ce612f102bf75e8a5ea923497b47a9e6135131ebcae"
    sha256 cellar: :any_skip_relocation, ventura:        "dbaf59201ef28a9d45c9b4a263a7dc66c0c6e35aa3712b0f4b1ec6c7ae4388a1"
    sha256 cellar: :any_skip_relocation, monterey:       "ff89be84c241acec1f04390ae96a3c5ea7abf3bf5831f72e486bdcc76245bd77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f1e34f17dbd338deb046a413b1172aa9e92010e432e1cfdbd9babb2d3de4d7"
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