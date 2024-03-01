require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.221.0.tgz"
  sha256 "f7d546061f48c12ee0c4cc0d344f42efdfad55ec46b75adc8e2a3260a46a1795"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b25d68829a1d61de748cb35d7959edc84f49157dd4186f0c49f2a83e55b4489"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4204f227b629c370ccab972a53536f27ebce2b04e06ee92e7bb3133fafdf4c7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f9e725c2e2f03281199dabc49090a93fdcad4983186751cb6cb1e355da0886"
    sha256 cellar: :any_skip_relocation, sonoma:         "b578ffb2bbd14eda21bb03d8ba08da58b4015f3e0558e8e3671e1edade9b57df"
    sha256 cellar: :any_skip_relocation, ventura:        "c93b1e241e90d3d03562b8d590e91c36847342a41e5d8206257299265279760e"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3d13d6dcf4ed2339ac9618b17da626df0ea1098edc07b79a6bdec46f025ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98681b62d186da27367ec65e8fe6cf5797d504ade4f4a145d0c186f08b791ba9"
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