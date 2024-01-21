require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.140.10.tgz"
  sha256 "660010f7fea9c2f87f658493bf32d536460190d7ca12e31bc53d37eafda708e2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f19d73bc175ae3c147a7b5bca7565b5e39e4f13c7a42c468403849f525fdfca5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c5ec12187abeabdb1a5529ab34137e730d6fac8944a40d51686157887997138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a503a7a326ed1e20da678104561b8c1ed815e60bfaa006b29cabe4f77e38baec"
    sha256 cellar: :any_skip_relocation, sonoma:         "48898ab86ca46105779631c77095e97cce5a66da5c5be2e91440b6ae6807066b"
    sha256 cellar: :any_skip_relocation, ventura:        "6f69976b3061e3d29f843c3c4b7a53bdc4caafb81cc79b1c824af6cee30e1e72"
    sha256 cellar: :any_skip_relocation, monterey:       "8130e13c2773517c69781e6adfae95cea4797af423d2c83ed4e6fb5531056004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426609f1f7f1ee766bac9512be2273dd48542c7842ce055bc9cdb4368cd91d59"
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