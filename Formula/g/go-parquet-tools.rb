class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.25.14.tar.gz"
  sha256 "a1c038876059a01c4b485dfef09bdcef1b59d3fae74df9988919e00848a674af"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049097b36f511703fa775f1d553659c37b2cb72499e42798875312f3fe620f18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049097b36f511703fa775f1d553659c37b2cb72499e42798875312f3fe620f18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "049097b36f511703fa775f1d553659c37b2cb72499e42798875312f3fe620f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "368fe0dd513a3b11402af9649e057011c9ae15db729d6efd4ec534bb484c9155"
    sha256 cellar: :any_skip_relocation, ventura:       "368fe0dd513a3b11402af9649e057011c9ae15db729d6efd4ec534bb484c9155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0367d549f30bccd01a49e86ac3387c257b493318cffd4ba7a5c9e75203979a5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.source=Homebrew
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
    assert_match "name=Parquet_go_root", output
  end
end