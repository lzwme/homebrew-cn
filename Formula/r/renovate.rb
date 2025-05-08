class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.8.0.tgz"
  sha256 "86b74d6799699adc138a83f94af53e8612510ac6f00a2af072aeb6ed2f64f67f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "746fc183c7b06629971b0d728eea0b5ccfe00503d58ba0f83d3c1368e93074d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9399de95d0500252f0d0a6cb08cec30579ea41e541659b288f7c2b6837b4b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e29178b11f2d9a4d3a71cf1a97fea05ad9b07a7a1505f89ab55616d8c82b7fbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe518f6f2e5b253b90944c6e5e162c3ad54c953f5b3fd6a51dd40073f5ed2c2"
    sha256 cellar: :any_skip_relocation, ventura:       "bf551ec7106c614ff2dec7e15ee64d8c126c6f063189c10fc70c4bcfe7600bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3a57320156d3490cd8428667e68c427b8ff98239978627faebd98e3fe12ca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d2bb3ab025c9552e376300a1385e9f86003ed2a9b6082a995449229ad2e147"
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