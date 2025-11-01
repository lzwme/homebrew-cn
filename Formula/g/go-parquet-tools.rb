class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "49de797aee4e1b07fe3b6d26bb3f3c34be73fab987b57b8066b7d37b1fc1628e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ca447e059cfd898c679a602a91c4a7c0cc910ca43c03cb6a4a322d72190e652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca447e059cfd898c679a602a91c4a7c0cc910ca43c03cb6a4a322d72190e652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca447e059cfd898c679a602a91c4a7c0cc910ca43c03cb6a4a322d72190e652"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9e08ec66097694ce10f3de3de53fbac94d1487792901cc9b3dca7124367e6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89518708c4a86a6ddb8571070d8a6ae78664ab3f2e8e9e90f223cd5f565af431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1255084380ebe197ccf7abfb6893f60340c6d9f7413b99b0b6d647e70cc1b7ec"
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