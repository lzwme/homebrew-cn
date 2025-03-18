class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.207.0.tgz"
  sha256 "7fb059924335b8074c4d3a06b9d754d69716a5c89d31943143cb3b7a69f90e8f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25be00b1b0db2a27c8785fe34f052586758b144e6458dd4036d864eac05828a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79bf1eee570da4482b562828493f52f84baf67e78cbcbefb03e871c962bb4bf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b9602a763094a7d2fa0d9d6e7c9a392ec20dc688f43025f814b476a77d6fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "caaa0e69ecb5a3405c8e90509b06d5a811c016fbc46379df31ef4a02c7433c5e"
    sha256 cellar: :any_skip_relocation, ventura:       "ebceb8d2cd6e34db850ad943806ff43fbfe9d960ad9b80bea38a21aa026e51ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6bb07e5535709837289c9db7964d9e281c8717cfd5c2f59faecdb7bf10ca85c"
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