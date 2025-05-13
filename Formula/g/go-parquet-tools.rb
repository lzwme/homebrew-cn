class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.29.2.tar.gz"
  sha256 "592362d864c7e7912c61e7ae788306422910733818765ba5eaf7422cfafbae02"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d3e0b1f254e281417294416b24a74281d8bf26984e59a39f5c997bd11bcc31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8d3e0b1f254e281417294416b24a74281d8bf26984e59a39f5c997bd11bcc31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8d3e0b1f254e281417294416b24a74281d8bf26984e59a39f5c997bd11bcc31"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f1207ff0a38d1f67734b223620ea154900c8239b884f3a921cc4bf0e1367225"
    sha256 cellar: :any_skip_relocation, ventura:       "8f1207ff0a38d1f67734b223620ea154900c8239b884f3a921cc4bf0e1367225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baade0545eae30ceaf614d707560c4bfdf64560a69b3671d40eb6a360cd33b29"
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