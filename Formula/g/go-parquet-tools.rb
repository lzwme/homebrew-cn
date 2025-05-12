class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.29.1.tar.gz"
  sha256 "702d3443e292e9d5ecff13c2a995457389c2f5dbb1f3e835f99ff9ea9d3876cd"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f81ce558dcfd8abe7ec81a2185c5cbb528c23a78def73e4519cc70d4e3cb1a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81ce558dcfd8abe7ec81a2185c5cbb528c23a78def73e4519cc70d4e3cb1a9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f81ce558dcfd8abe7ec81a2185c5cbb528c23a78def73e4519cc70d4e3cb1a9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc3065518dae36e123c0c6bd7e0de4d219a8ba911e195e81e8e88abc70de33d"
    sha256 cellar: :any_skip_relocation, ventura:       "abc3065518dae36e123c0c6bd7e0de4d219a8ba911e195e81e8e88abc70de33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ca14331561b1c214235076cd5f7602c738bb1a2212fff0afdf37c10b00a97a"
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