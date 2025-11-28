class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.4.tar.gz"
  sha256 "7510697fdc3c71981b395c07f10e1417bc2fcb8cb118e158ba80dfbee0f45c70"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e50d9d2eac63c5a93721524d2ab68229db8768b6bcf7e70e7025fc8d35738d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e50d9d2eac63c5a93721524d2ab68229db8768b6bcf7e70e7025fc8d35738d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e50d9d2eac63c5a93721524d2ab68229db8768b6bcf7e70e7025fc8d35738d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "21bee685e11faf2f859f8262c7bb8745bafb2126ba40cf94bdc08230ec9b6c69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ebe8eddb69bf66889dd58652414ac6949ac769520d4cdd8cbb08438d8cf2f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2529fc3c2c11f94f194447af8410bcff3a9292958e4e20d59e4d2c414b80494"
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