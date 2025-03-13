class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.199.0.tgz"
  sha256 "e06a2638f25fa9ff7683a6e90b3bd887055bbe25ab732c18b5c7729c81d25b29"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c740bcf5a796ef6c39f4334d5119cb213368d5448b4af4ece3e5907b3b56ee11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "011ad6571aa9bf2082b851f35f809782048409574100214b9965948a3d71dc0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "834aac44089e8f8b965e430774010b6c38849e0d67c65f0274e6d6c1a1a5c2b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b782551edaaeaf24d12c87522edc4d133af90a7872ecdd8626a5c196def546"
    sha256 cellar: :any_skip_relocation, ventura:       "12ba4d8357aa4ffb44e628341ac316ce4f1c104fe4601037fdd8eae68ce78bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456f31c98fbc7db1e4cbf8618eb3dfb606257bc8df58f3aa734ce450c40723f5"
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