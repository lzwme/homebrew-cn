require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.213.0.tgz"
  sha256 "7df7af68b4a0a11c195d8ff5cd45d953450a400015e124088abd3e3a35c1a33b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "195669e413381f1a239b8b9d981afaf6e8132cbb5aa11ee6541089fc6151d5c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f79eabd46cc866d736b5678d878a50017f1c4198115cb4cd8f3ef4c86f32bc8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2182eaeb237f27a61264a4569c95421be28767aa9292c8e39dcc3cf2c7422a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fe522e22aae5d6c93ac74e9e0d287e41a11b541eba5468dbdfe2c1ccb7df8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "7e4bcdfe0a19b3f41044d2b6f6d372a831171919de4ab089cf7932593aa80df7"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7bef94f828fcd2d3169f34ceccc4fbd388e0d7f19daee346af514b9ff08eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "833f654ceea6cc8053eb25252ca782c0d8086178b7459619f55a3791f80725ac"
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