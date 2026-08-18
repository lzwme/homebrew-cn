class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "d052b1403981d9363e803a11d46ac849178b20d9607ebd914cc78ee3b34083ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fe8a275715b159521b1cca6acdeeda62b2b043389d92963391f8c9b8e8e4c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84237586efdb1481fefc947ad4243fa806d103bfbca28c73d7b7d8fb1442da04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26210b723b3fd01ff0248a726f4c1c2c5d3a40f64beadb47ba13b65754497633"
    sha256 cellar: :any_skip_relocation, sonoma:        "5078445a7d72a680919f47e4dbdca1757fb8002d970616e8b5f3543c044ec0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8b7af61dad5185425cbb03a80491ea30efc8370e63a040b2ccd497f9eb74b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94943873e41f7a6d474f3a29e2a9b9f0e219fdded2f6f44773e36adcf74e408e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end