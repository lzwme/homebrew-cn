class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.84.tar.gz"
  sha256 "6bf04d28ec4560fabaf6c816434040013d0196ae8a0129f55e9ce821f1b86a2b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e945ea8dafc0ca7e37bc4ba48155deb36b134f99c1d8f4c174aef61cf78d869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e945ea8dafc0ca7e37bc4ba48155deb36b134f99c1d8f4c174aef61cf78d869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e945ea8dafc0ca7e37bc4ba48155deb36b134f99c1d8f4c174aef61cf78d869"
    sha256 cellar: :any_skip_relocation, sonoma:        "f03521036f5f005b947718ca632348d4b5390344dd63fa7a7078427d2e65da42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b973fc48fab4486915b02b22a726e8fdc85405490e327a0cd52f1dc195b30162"
    sha256 cellar: :any,                 x86_64_linux:  "50c6d6fc89119b8d278c9fa17d0456d3d5f3c99c5da194c5069ddff046c010ce"
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