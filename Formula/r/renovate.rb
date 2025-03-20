class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.208.0.tgz"
  sha256 "fefded9bfaec7aeab1ae9d57599450bb5f57bcdc66c8d32482cc4d35d5341291"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ccd0e2a68d60278294bdd6fde600eb85b235731adde192cf07c5ea44aee008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f692252ef4ac7b927d1d7958cb505acf3d5e112db8249edf409631f9adce695"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908870ee1283cf141345867905f8cd93ee1ff6c93b8c3efd3d7e50e3e5e89192"
    sha256 cellar: :any_skip_relocation, sonoma:        "c929e55c5c4230ba2d1424c45da13564f2f9b6aa4826ee8ff8ed935898d1259f"
    sha256 cellar: :any_skip_relocation, ventura:       "9c8ab095128fe6257b8fba969828219ed5b8146be62ea7dde24b63f787016b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71ba0ad7b7e17d07da3475cbab419872e3eea55852198ab1aa4c3c45c31fc46"
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