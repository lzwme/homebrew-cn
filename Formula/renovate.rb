require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.113.0.tgz"
  sha256 "3f7d54cb41f00b0bbb53fe639ae2ec7743cb0445c2371f5ea6cbe9c756f0c9e9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e29ab7dd73742c9912d8deeabc9526138eeff691bc078598cda32e520bb93bd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56838766f50d86445d2a3dfb0514ef5d72374c71cab05433c089b006f76d612d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1155554ae28198192104d489894fa5c2aa604a83da2f5d039be9a77689293f99"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb4fa2ec4ec0d19ed8b8f284b03354b6631c9c16c813c3ba4462b40fb8c5b47"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec38271f4bdcff93260435afccdde150be4583e5c15a959411efb4815539a66"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe0daaf7ac95dda4326dc1f2898d228ca4e59840c9f3711ae1d008c82c2d768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "220da1155a7a201333274c455120dca0d793dbdfa5becbebd1326789c1adc564"
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