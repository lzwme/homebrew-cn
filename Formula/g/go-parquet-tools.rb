class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.3.tar.gz"
  sha256 "5dd4fe21da4084bde58494d77cbd29f4b90461e5cb59e6d85ddee4524d65f16b"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ab3ab4c7be78254e7fb405c88715dd5f2683a50728a3ffa1dac9b600f1420e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab3ab4c7be78254e7fb405c88715dd5f2683a50728a3ffa1dac9b600f1420e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab3ab4c7be78254e7fb405c88715dd5f2683a50728a3ffa1dac9b600f1420e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c3e58274c0312f4e5123547894195ab130dc48f70e373ac6dea052983e7a462"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed674f4b5da73319be90fab34e6f575d84528785d376f52c6bfecad983c18e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8894d44e665fef73312d7a661a0d7bbc433c3258425d03cb94f9c38490c47c56"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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