class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.63.0.tgz"
  sha256 "2263bc725808c90d50d95857645a713997e6015d4a162b8bbd99d874d2ed96a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da08109dd9a9ea501fce6cdaaca87c0f6904bdb34bf478c6252e39e24584dec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65a482e3b426b54b6c2c1b6e9dc7ce963d0a53b2d00b61499140d8b368bc909"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a383b2d6e0e10cbbd7b23025017da6f6e36e7de48a123246baea1594fbd122c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "244cac852f0d01e2479625b4420c14b065a89fb85ce3d0fde8a49077b667fd5b"
    sha256 cellar: :any_skip_relocation, ventura:       "e33a99134032ad17e698088479429c684f3ea168cc17630e452cfadc3074ef99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1db25bec15b66e8872aafd11e6828dccb159b3518794227e9bffc8d4c9ad705"
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