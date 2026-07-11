class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.98.tar.gz"
  sha256 "d6acc5ab7ce378a3e3441f8e3dcd4c052417fe2d62ef87ff000c33703bc2118f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c6246a17dbbefe49314c0d1d75f39d4f075a9ca349d4f668f0772f4b23d892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31c6246a17dbbefe49314c0d1d75f39d4f075a9ca349d4f668f0772f4b23d892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c6246a17dbbefe49314c0d1d75f39d4f075a9ca349d4f668f0772f4b23d892"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c61d07379aff4c0b5f9b0d31fd4c30f61ad1b526a0d412af9365b4d24dcac13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df4f0b6c0d23c97d6ce66b21911bd2a2d5f0c0ce4ab9a55b5c84fb4b24dbcb61"
    sha256 cellar: :any,                 x86_64_linux:  "a7e6eeceed82239c6d7bb0030c70616c9a0ef6eab2c10620de843e30039f6750"
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