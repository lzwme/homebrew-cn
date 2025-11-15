class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://ghfast.top/https://github.com/0xerr0r/blocky/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "28afb06551a0d76790db86a90783abde287531d2dc095164c0bd8647e78bcb36"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc18fca9c6e9dd2f2be83a80b632fd7824fa372fac22a25a561d9d3cbda18613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db8da90d01e6b447c5b048cbbba67dab43a0f98a7a726bc158b9de3b35f473f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "130783a65cc2d6e3f33215eeda7783dba5f795669a1bb61f9a4752808b72151f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3701882798c251573d307e845e0d5d104f14038108f11e510e5a9d5240aa8ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5904ee2b3eb3a6b2f8cf0bceb3ed8cb90c145a4df9c5cfd61c3e1835db977ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bd26f1dc5b488387ec113441bcf1b92750909e30057407cd3a6dfe464f75a9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end