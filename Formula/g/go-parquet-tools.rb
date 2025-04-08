class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.28.0.tar.gz"
  sha256 "a45c98b28e378708ff794fcf497b4b93403b2212543fa22991dec255fa9cae13"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41b0140e8286b188baaa8b9cc16339a6d97a97b95cdfa043aa61f79d8648234c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b0140e8286b188baaa8b9cc16339a6d97a97b95cdfa043aa61f79d8648234c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41b0140e8286b188baaa8b9cc16339a6d97a97b95cdfa043aa61f79d8648234c"
    sha256 cellar: :any_skip_relocation, sonoma:        "80dd869d046de54b58783e715f14b3e39c8194faca04325e663b051fe69bdba3"
    sha256 cellar: :any_skip_relocation, ventura:       "80dd869d046de54b58783e715f14b3e39c8194faca04325e663b051fe69bdba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f395b03b4d5c08e35619a9a42e17e79194bacde2f732329c2529e56466f96e"
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
    assert_match "name=Parquet_go_root", output
  end
end