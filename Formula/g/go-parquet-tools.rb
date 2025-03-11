class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.26.1.tar.gz"
  sha256 "51a950d6c779fec2efe65eeabfdef5fd9dc252cfb0cb9cfef915bcc41c867fdc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c295a89822e0a3f458267ea41abee2ea472cc37a460cc57abef1d6683f379d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c295a89822e0a3f458267ea41abee2ea472cc37a460cc57abef1d6683f379d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c295a89822e0a3f458267ea41abee2ea472cc37a460cc57abef1d6683f379d7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "75b254bdfc99492993df8f0ffe4e8ad659a0eb11ade9445411a6f55a98857e0f"
    sha256 cellar: :any_skip_relocation, ventura:       "75b254bdfc99492993df8f0ffe4e8ad659a0eb11ade9445411a6f55a98857e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baebb4667af1521d5e670e271e9cf12168ac49dc62bc6f7afec6518190de52ba"
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