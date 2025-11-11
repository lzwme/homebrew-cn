class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.38.2.tar.gz"
  sha256 "47d982946fd4c9392cd197a264d7d2d57047cbb472c35cdaedd0ac626153a2b1"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73195c2b980ad6b6584c66870f641398b4b362f41d847b57a59bade9d3d7b7ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73195c2b980ad6b6584c66870f641398b4b362f41d847b57a59bade9d3d7b7ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73195c2b980ad6b6584c66870f641398b4b362f41d847b57a59bade9d3d7b7ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "99d962ce8b1834b9e3c24a238489352b47acc9a6d02ab4c3ca1fc68a459b32f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bd6a74a76b4722f08985b97ec90aba7471088d7efbb8ebbba206594dd5afa97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd56d36e0001dca32abeda2cae9111ae15ecd1c0e7b46729d43ab6c05d5a822"
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