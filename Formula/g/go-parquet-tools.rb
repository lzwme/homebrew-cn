class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.8.tar.gz"
  sha256 "c6f368cb686cdb69f7028dddde5c8cee3af56fb3a0119b05e5716c433468a2c1"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71423b62013d95eb64c8f56f12d093c9405ed75a96742dc8d8561920ed166c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71423b62013d95eb64c8f56f12d093c9405ed75a96742dc8d8561920ed166c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71423b62013d95eb64c8f56f12d093c9405ed75a96742dc8d8561920ed166c8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1841cd8539462d652b2cc96051a793a309b747b06ef18573832f5fd503d34de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bafc77b50b3b6ab6078d978e0bcb878a19a560a8931b5bfe8070ad24d0e9fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7033b0418e740ee3b7be9c16a7b36c576ea9701a471c8f31d4e97a4f2772bfd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end