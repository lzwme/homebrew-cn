class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.32.7.tar.gz"
  sha256 "d005949d93e15014c1880bf62c17ab54322b37295bdd1160d0c28ed593665f2e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12aaaaf7c37f299bb3f6f13596c742fc0af41400ccf0218671dee378183bebc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12aaaaf7c37f299bb3f6f13596c742fc0af41400ccf0218671dee378183bebc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12aaaaf7c37f299bb3f6f13596c742fc0af41400ccf0218671dee378183bebc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e741bab1a4ae8f9083604834889713cf1b9da5155eed6f4da423f342c2c6e074"
    sha256 cellar: :any_skip_relocation, ventura:       "e741bab1a4ae8f9083604834889713cf1b9da5155eed6f4da423f342c2c6e074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f7ddbe4cefe41c72f650a3aa436c77a82ed5247b2726c78d37f48a260a34c1"
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