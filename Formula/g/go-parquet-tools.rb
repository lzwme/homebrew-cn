class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.5.tar.gz"
  sha256 "64884e5846b4b86546d9a8cacc66256e63be526f0315b6478b0018738b81a225"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "284891411fbfad4ecb6fa032790f8303285205debff4c44421c011b55de54c9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "284891411fbfad4ecb6fa032790f8303285205debff4c44421c011b55de54c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "284891411fbfad4ecb6fa032790f8303285205debff4c44421c011b55de54c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "baf531986d079d1f4f90fb24fda49029b32367c508114262e989b754559f5f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c02ebe238a81dc678f0c2589161f8aa4d92a171a451fd0972ac4a27aa14e395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9ba610e28f866baf75e990be6c4159d0fdd1c00b45b468b2efa787d34d72aa"
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