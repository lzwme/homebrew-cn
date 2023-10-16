require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.20.0.tgz"
  sha256 "d0d1d76e7a0016b2bffa5eb3f8e43479154e8ca36db9b680ac98cc1713d34be2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb188ca393b09569484d12a1aced1896bf204f840704dfd746aa5fb8eab212a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8292ccc6e37aa2306607e5fe2d053e437b4533066912cdda70027268c482e672"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eadee55bf05a691c77416a027878c401d658676de36e6992c651d6688282cb8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "087500b23289bb2040b90e3aaeeee6304ae5e1b10f6d74eb266fd10341a521cf"
    sha256 cellar: :any_skip_relocation, ventura:        "3f0c29369c85e340fad8d8b651074976d4409acf42256e84098260e816320dd3"
    sha256 cellar: :any_skip_relocation, monterey:       "5b69d6c95c39d5fa55e784608f929ac03e1e3dbd169b10ca1b795beda18bdaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c510983d5f644687117d70c8656f41137e030bcfbb587bffea90c9ad1ce2b7a"
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