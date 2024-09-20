class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.89.0.tgz"
  sha256 "d1459ff1828e9abd0ef44b28a938548c54ef4f527abb6ed7bef54987ce941353"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44788670895f2c73aad81f9f370a29c12c113041a49c2508f1103f2932204359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "159dc8fe5a9ad88b0bab87390ee59190bf5b9b7e8dc2c70758960a2ca2710805"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6912ceefe3c8b0cea0c06ff0d2ca37b3556879f27894e079a7c816c4b5bd540e"
    sha256 cellar: :any_skip_relocation, sonoma:        "89044fec9f4fa133d28e9a1af6098fc9aa28e14372bff9f21853b44aeddccc67"
    sha256 cellar: :any_skip_relocation, ventura:       "5f6130d5c217bcd2b3c824458db2b9bb25aad85e18c2043f617600a57b9dc825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20695d1e27e6cfdb255ac82930ecad74ceb39de9dd215e6dcbf9c3380a2bc779"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end