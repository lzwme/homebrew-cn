class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.31.0.tar.gz"
  sha256 "8f6734b487cead29c2205f8e16819b13f177477cb895313c128798a2c40a4579"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cadcead1a0b8b652f52f0eb83d91d04d791e6b30b4ce5c18f76e74f652005a5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cadcead1a0b8b652f52f0eb83d91d04d791e6b30b4ce5c18f76e74f652005a5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cadcead1a0b8b652f52f0eb83d91d04d791e6b30b4ce5c18f76e74f652005a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8346b45f2c8ef9b3f64a07365f297fedef2b21fa1b2468c17cbd69832faf6dd"
    sha256 cellar: :any_skip_relocation, ventura:       "a8346b45f2c8ef9b3f64a07365f297fedef2b21fa1b2468c17cbd69832faf6dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2158908036553150da24677eb25263962b042698c01a301d93181d16103dde73"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https:github.comhangxieparquet-toolsraw950d21759ff3bd398d2432d10243e1bace3502c5testdatagood.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}parquet-tools schema #{testpath}good.parquet")
    assert_match "name=parquet_go_root", output
  end
end