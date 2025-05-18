class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.29.4.tar.gz"
  sha256 "4ed9bef0583ec06cc6c0fa57ca6bb3edc634255cf8529bf9619ca6707707ac6f"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "088030c9b75776c49a3d29f0e852326281bcc4c22be362a827bca07d3bf42f20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "088030c9b75776c49a3d29f0e852326281bcc4c22be362a827bca07d3bf42f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "088030c9b75776c49a3d29f0e852326281bcc4c22be362a827bca07d3bf42f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "5335774d829af180b5995ca91c2cbdbb6f5e0fb508a6228ad7da6c82f0d43d14"
    sha256 cellar: :any_skip_relocation, ventura:       "5335774d829af180b5995ca91c2cbdbb6f5e0fb508a6228ad7da6c82f0d43d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5727c48a12d2996a0d369b2c6d2d40c20253e412c9abb920909323cc31a7e831"
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