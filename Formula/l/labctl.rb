class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.103.tar.gz"
  sha256 "7e990a2353182738b4ea71c55e81019d76094b540c9bf00b381803067daf3ac2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b47bf01cd7061c7c261fcece40eb5759acbfc71727efe65f17f3ed56ccc17357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47bf01cd7061c7c261fcece40eb5759acbfc71727efe65f17f3ed56ccc17357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47bf01cd7061c7c261fcece40eb5759acbfc71727efe65f17f3ed56ccc17357"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef2bc504a673ee99fadc3172fcaff9b20f1bc84c05bbb700f9dfb0014253d0e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "861bbfc84c485f4629d759551efb880b7d06e875c8119da322ab48fb4676588a"
    sha256 cellar: :any,                 x86_64_linux:  "b7f23860bd00e83a610edadb0ef1bb959c833f3e18767b3bf68cdb7ed0858b62"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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