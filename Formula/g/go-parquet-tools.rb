class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.30.0.tar.gz"
  sha256 "4a935064743c45e907e2068a2dfc03fff393fd2847aa61eec1512090ab8a3da9"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "802afe6be74525471120611f4b30c0869543d22f207c05c960583475eb7e38df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "802afe6be74525471120611f4b30c0869543d22f207c05c960583475eb7e38df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "802afe6be74525471120611f4b30c0869543d22f207c05c960583475eb7e38df"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb835a11ff4e47ebffce8dc941627ecbb7fa1d1a738f7bf277aca363500ea35"
    sha256 cellar: :any_skip_relocation, ventura:       "4cb835a11ff4e47ebffce8dc941627ecbb7fa1d1a738f7bf277aca363500ea35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874f0e5d98f418306be43157e5c695c3c5ac8e44937acc24ac41e6781f894fe1"
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