class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.25.9.tar.gz"
  sha256 "61df81b68b58cfccd6b819bc3edf50e6ecf58e294195167517d71076fb047fd3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc38ca450eb9d0f1843e6e10e93cc107ecb804f0cf1d91f9fb77032b387175ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc38ca450eb9d0f1843e6e10e93cc107ecb804f0cf1d91f9fb77032b387175ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc38ca450eb9d0f1843e6e10e93cc107ecb804f0cf1d91f9fb77032b387175ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "74cb4880214635871a752c27a47c76400c52860400e2bede6c69ea7d9a1f0104"
    sha256 cellar: :any_skip_relocation, ventura:       "74cb4880214635871a752c27a47c76400c52860400e2bede6c69ea7d9a1f0104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66fc030869fd9fe6e0781601ce1b2da8797bcdc68857d563468c4d756c7310d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.gitHash=#{tap.user}
      -X github.comhangxieparquet-toolscmd.source=source
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https:github.comhangxieparquet-toolsrawv1.25.9testdatagood.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}parquet-tools schema #{testpath}good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end