require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.87.0.tgz"
  sha256 "206a565ddb31667ba1f1c097d134a7ec589ee0f3a94c9ef1615d3fefb0ffb731"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a16e132c9c3624af47504b86329353ba28287cb18651fe1595a8849825bb15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3462256c2a4c5580de2be5898cda26390cff83cc1ef0c381b59025a04e93b4b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2aefec56268cbc7b5de49d973fd349fad1e2d75fcfb87ea484e20f23ef800f4"
    sha256 cellar: :any_skip_relocation, ventura:        "726907b295bd789d532e3211538682194dfc568c2f21ef6537e93347cf694d4c"
    sha256 cellar: :any_skip_relocation, monterey:       "32c9c56d498baa7916555c110e1908b744646251c670c0643ce462e89fb0fe7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1a810caed070c7ec8df6eed6ca596b25f6966b68ff5cd9753db9649a9187051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a70234b159767e9449b1d35240c7e9b20c665a4eadc8c1db520324887fa72b2"
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