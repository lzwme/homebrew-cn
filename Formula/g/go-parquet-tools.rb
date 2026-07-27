class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.52.3.tar.gz"
  sha256 "384de964b9d66ad25e5c5ec598085386af4c8ffcc1d5ccdcd4d97cd1464fa14d"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65614674d1c00f9a5ab6e082e7a10240048822a07eae7d5587bacabc111b8f16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65614674d1c00f9a5ab6e082e7a10240048822a07eae7d5587bacabc111b8f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65614674d1c00f9a5ab6e082e7a10240048822a07eae7d5587bacabc111b8f16"
    sha256 cellar: :any_skip_relocation, sonoma:        "263694e8222705e0376f3a168c02a97b97ad6187419467accb8d9afa1f96db81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab8490f0150ed0acbfbd5f075e1f0a844ef501772f08637829975e37b82e6c9f"
    sha256 cellar: :any,                 x86_64_linux:  "ac5359064ece4b7bb389c282e70b78d45c896dc6d1243a47df5137823262b51e"
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