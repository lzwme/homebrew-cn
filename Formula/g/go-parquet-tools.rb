class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.9.tar.gz"
  sha256 "786166c9cf0d9c359ceb55f9bf687706e9ef47f6314b9b8ee53471f7569ae946"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c97b292c490a5a8e3ed1c53f838d56fa34bf6836182eac75c0c3d75e5be7e86e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97b292c490a5a8e3ed1c53f838d56fa34bf6836182eac75c0c3d75e5be7e86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97b292c490a5a8e3ed1c53f838d56fa34bf6836182eac75c0c3d75e5be7e86e"
    sha256 cellar: :any_skip_relocation, sonoma:        "13429577e9ab1435f1814be08ac6797f21476212de3dbc3355a4ddfd044ff20e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a62370389421c7a27b1b4294e686babb2ee59721ce2fe91fc8a59173413d6219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b8a729e4f5cb04ee13ed05b47be04a6176df1d51069d602048259ad834d374a"
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