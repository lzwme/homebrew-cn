class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.96.0.tgz"
  sha256 "3899f7a2543ddb1bb5f546a97891c178522a952a106aa25fddd7e3dc368330f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423a6bd0d752a8a12adfef496f055c08ea850225ae74e3ae4e043430bee0e14c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "572a182d267204817ed8c9abe0773bed6f63c99f2263a5273095a4257aad0868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2a34e70defcc264d7566b28c92a06518ae88ec36e284166388cb0d78de30acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad9ca10683c9a4d0eb0544c593fc58efcd255fa8341e8ed705c6aa8780f2d623"
    sha256 cellar: :any_skip_relocation, ventura:       "3123d62d904ebdcb19d801b204fc019031cab308905971737b6c9820d0ec0ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23623f32752ecc34651e28560d93efcfe7a30eb2fb3108341951487a905618e6"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end