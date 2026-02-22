class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://github.com/iximiuz/labctl"
  url "https://ghfast.top/https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.61.tar.gz"
  sha256 "e2111b3225cec8601ebf78768db2970c1fb72e9b7ad54f6f2c67ef50f88adc87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f443936dc09347cff9e80d69d666fa5cd532d326a1558cb133eced28896473d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f443936dc09347cff9e80d69d666fa5cd532d326a1558cb133eced28896473d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f443936dc09347cff9e80d69d666fa5cd532d326a1558cb133eced28896473d"
    sha256 cellar: :any_skip_relocation, sonoma:        "98e84ff460413353e7934aec0be1b1b6b010a6d0e75af0f42a59d20241c66fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0f5c1769c8464c8d7ef2694676c1f5dce557e52b69762a1ab1133101e166d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46d38130df7906f8435b6f683bcf7f6b1909666e91e0ccdcdbb72c2a9a752d20"
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