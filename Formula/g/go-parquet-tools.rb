class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "4d0140e06d04728a045e2fc39b282976b1396b0cb7541690590667f41ce7072e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b6ddc35c604f7c29560484ea3aaa9544cf3cef42072bc73752d9dd89d6821c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b6ddc35c604f7c29560484ea3aaa9544cf3cef42072bc73752d9dd89d6821c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77b6ddc35c604f7c29560484ea3aaa9544cf3cef42072bc73752d9dd89d6821c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5296d11ee3eafb49a716b76d25c5e057fe9488a3a1d073d4fabd0d07090d0479"
    sha256 cellar: :any_skip_relocation, ventura:       "5296d11ee3eafb49a716b76d25c5e057fe9488a3a1d073d4fabd0d07090d0479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49876feaff6525d36da4ed12b9ff5509f6b5e3ed330cf21f726aea5d84c9124"
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