require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.68.0.tgz"
  sha256 "16c1a296517e86cbee3b78feeaec82aa655a97206bf7cd56e85e2353cdd3869f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fe9810dd2dac421d13c1429684dc970b02720c24e064a0db7e65b10b8d982b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9d52118caf1bbe5feef9b4a930d1155388343f6882746d8b43c12f39222564b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d715ed9c27af4ac9de3f362e98cbb92426e493f2ff3f12df5d62a1adf69d2aed"
    sha256 cellar: :any_skip_relocation, sonoma:         "19c60380307662c071f6e07fdbffcecab04a484e237e1537f8e1911258fdb1ae"
    sha256 cellar: :any_skip_relocation, ventura:        "571856f6e493ecc7e868984eff39731cee08e76f43925b7e81707c37a659f932"
    sha256 cellar: :any_skip_relocation, monterey:       "410711e82594da7a8d09b2da201b33a35d4d09f307d620c6a3eb65fa150d2f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f98c26e816ea8588f108db8f36847908f904441086a3e2393c9b25af104280"
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