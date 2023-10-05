require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.6.0.tgz"
  sha256 "9e43d89c72d09737022fa1dff361be7027c4b7f2fd117d5689ae080f3ffb3b73"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f62fc710489e0bd7e6531b7cf8c251e3d3519c626f512dbb99234c6eefe5f48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06cd57168f2ec120e3015853f7611bb5913b31c9b5e529f4b9c5f483491260da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2fbdef896140cf8028aab14a5b3d2048631964b23f409e41a8de7595ee80c3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c49115293c3314d4c28b5d5ece7f4b209450ece8ba4e62036953012821789b4"
    sha256 cellar: :any_skip_relocation, ventura:        "7f2ea7ec6da9e819fe2faf4889969e637f99849aaab7e47bbf06497548019118"
    sha256 cellar: :any_skip_relocation, monterey:       "70475f2d72414a791ccc2682054127b4b952e4ad9371fdc6242d5bfbf4a6124a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36fb96ac1bafd5fd482c71a6b8b4de89fd6894e40e168ca5e4f352b978c9ea4c"
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