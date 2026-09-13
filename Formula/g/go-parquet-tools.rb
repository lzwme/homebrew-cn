class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.55.1.tar.gz"
  sha256 "53d36e0a1b8624ed962769541a795ebced98a77358274ae6cca07ffdad0466af"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "021056a9dfaad457c794af07efa6177707556d37413b75831b9525aac201aa35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "021056a9dfaad457c794af07efa6177707556d37413b75831b9525aac201aa35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "021056a9dfaad457c794af07efa6177707556d37413b75831b9525aac201aa35"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ea0705a4325fd4234b3ea27adacd606f15518001990f260a74bcd7731080126"
    sha256 cellar: :any,                 x86_64_linux:      "ce17f97b3200af332e3c0cd2b7b11df507c2bffda8fd350d91223558c06da874"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end