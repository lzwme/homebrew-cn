require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.117.0.tgz"
  sha256 "0bf586d6570553aba1d9c3564124d80725f527e4de7c14c76e2a737517e15dc8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df1b68747004756ee7d3dbd16766a476c67cb1a2fd0febc6d6a553e43b5e4e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76fa0bfb03523e602df2ced379cb3b65e0a154403ac853d18cd2ea7174303ab0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "322280acb81682facd373e87040a6c565e4af7d6b7ac0aa850484dad092cee82"
    sha256 cellar: :any_skip_relocation, sonoma:         "299451e529e82d894ced1234e9586eb08a522cedca1c837da2fec397eea17707"
    sha256 cellar: :any_skip_relocation, ventura:        "807062db40286aa3fd7519b1195f02aae193cb0e66fbc53bb89b7066d0484335"
    sha256 cellar: :any_skip_relocation, monterey:       "11b6aea22e959a9ec18228a3c199543cf874814a2c56b962b4bccf871b0d7117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1108be0c66e1db6be143ccc1bfeb574ad483353a5b44a2764d3801e67cfcca45"
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