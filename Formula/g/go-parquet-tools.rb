class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.32.1.tar.gz"
  sha256 "d3ffd001f769797c0b2dc48a3587b544b0e99e4777aade7ccdaef3c46d7b045c"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af2c104c29c617170065a3e9d2714a4a6adabe9119cc7580c15212514c30f985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2c104c29c617170065a3e9d2714a4a6adabe9119cc7580c15212514c30f985"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af2c104c29c617170065a3e9d2714a4a6adabe9119cc7580c15212514c30f985"
    sha256 cellar: :any_skip_relocation, sonoma:        "07b60729c9f95feb1603c7c5e29a00f8de4c8e712b718ec0e46f3f5cfce566d5"
    sha256 cellar: :any_skip_relocation, ventura:       "07b60729c9f95feb1603c7c5e29a00f8de4c8e712b718ec0e46f3f5cfce566d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6ae6720b21167a5e0d0642f616a04bc1ec2e34f0cb0dfd5c0d74b85ca7218b"
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