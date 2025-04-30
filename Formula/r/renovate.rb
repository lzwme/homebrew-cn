class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.263.0.tgz"
  sha256 "0ca7058e301c559f3c70c624d5aca5b92320e1af01deae8d39c7d445010829b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50e06f4cd5982521b8c7dc4e843c17d242f5fe52be381de63e6e34f30372c5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c767a3ebd7ad62af007af00f44c6c243fb96bcca7b5fc0e0ea2b73ed972ee8c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2e37a390402c66bd6a8335c9bc1eecc9125f6459872f73e2d5c653a3dd3bf76"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf68cca8e08cc290ddc9e7c281793c11b6e2a15222b10782a18ff0590dc397d"
    sha256 cellar: :any_skip_relocation, ventura:       "f1ad85dd0a35da8decb8bd9adb9b3ac0725f7b1187f2812931d8b827bb0dd90c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06707fea9271ad44ca36d4e6b69fcd35d4f9f5e42c11076b7972d63f0d1b3f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4708acc57f749e51011a9c0c3128864ed1f1cec781f829cd4e893a6cb55e08a9"
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