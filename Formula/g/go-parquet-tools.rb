class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "54d60e56fdf87afb3c7afbc0807c03f3c766b80fac06b5bb6b58e92030bf9083"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbf7301396f5b033e6bc3f9126e3ad2a00ca80620ca1448cd92b76abc24ac743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf7301396f5b033e6bc3f9126e3ad2a00ca80620ca1448cd92b76abc24ac743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf7301396f5b033e6bc3f9126e3ad2a00ca80620ca1448cd92b76abc24ac743"
    sha256 cellar: :any_skip_relocation, sonoma:        "327c057a8837f8d3b8db4bb66a9edc1b925228b3148367374dfef3d101f4e63c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eadccd976d0ec25ee9907fa316dcac57cd6331f3266433249c5543dc3039aa99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0861aa048923065510f2873cfe6700a03414c114c38d4bbc4d07bb119124f3b8"
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