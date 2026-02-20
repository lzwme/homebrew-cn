class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.60.tar.gz"
  sha256 "b942c0e053a42d7384ce46dd38c921ef125f158e98a173940f33d6bd12309418"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a66b05b6b842c2c8133bccd8260672b80722e604bc43c3bfb7a96dbd18da57e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a66b05b6b842c2c8133bccd8260672b80722e604bc43c3bfb7a96dbd18da57e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a66b05b6b842c2c8133bccd8260672b80722e604bc43c3bfb7a96dbd18da57e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8115864c1d494cf68b2bdc803ffb4154c341c4344737869e776ec305a73a21f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e67e8e916192400e00dbe81ca65ff2612a1daf16019c65d9d5a51041b4c98d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7404f03f3d18c43f60ebc87945810c21b8f9e5aa660d5045b5082013996d4b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end