class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.95.tar.gz"
  sha256 "20f018d71af3bd4a50dab8cbcb80b719f8d4a3c4f997c78c13b43ec1e666e300"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93eb3565f787d8e12e4bcb98a8141d8d051a2c3336fe61e00c6b72206b589793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93eb3565f787d8e12e4bcb98a8141d8d051a2c3336fe61e00c6b72206b589793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93eb3565f787d8e12e4bcb98a8141d8d051a2c3336fe61e00c6b72206b589793"
    sha256 cellar: :any_skip_relocation, sonoma:        "7926ad6ebcc374cc1fdc79e96f89d64a852572ccd055011fe1916cf151f5686e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccc95e1e2ad36f597fa37cf7f82dc054ad418177e5e694e796aa3db94cfe33e9"
    sha256 cellar: :any,                 x86_64_linux:  "293fd2a01d02986888532b86f861a155497042ab5e53656c81dc46604272b528"
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