require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.74.0.tgz"
  sha256 "d92353e7b7fdc8ba19490f4c7266e32ef83ab1f6fe2fd98407efd2020926c887"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c279f49beaae257d648e43976e012b35c60cf67e35ba26cfc46988bd590d3ea6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3453273a45a60e0017c5fc79ab36edba2311c9ac5f898bdb65ff026dd4f404a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bc77f31a28e044b68b94426f36aee81800cc0877a6ce893b9eaa11cb62c02ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb0246ef53942fce4385ec45e7ba016b7f0a5a4a6b1022cacb5cbe7547ef5bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "80ca95d6c5e875dd4efbfc1df821824594c0bed3905fa8029b4a87bcdbb74c3f"
    sha256 cellar: :any_skip_relocation, monterey:       "eeee05b816e59c0539642b1622903d0276dfa6ea3095428f3f0a456fb4e8db28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f302c8a72b0eaf0b1439808dca2a2ebedc97cdc7f1e3ee6ee503e3582550991b"
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