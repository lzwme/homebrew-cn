class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "c04f83a5461bd0c8a9b7ecd653ee3eb605fd31d197627caf44d3a6f86c5d6bf6"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a72236bc545d6ab74552fb4012c429d1feb228f1a0f915aa473ec80f9e64c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a72236bc545d6ab74552fb4012c429d1feb228f1a0f915aa473ec80f9e64c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a72236bc545d6ab74552fb4012c429d1feb228f1a0f915aa473ec80f9e64c6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2463f56a02ca477cc8589e4d8c63e110242df7c4193996a9fd648cad8804ebfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "122627bed738666b5dd10492666ab7eaca7bbeda9c8ccf15654a3d20c92638ef"
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