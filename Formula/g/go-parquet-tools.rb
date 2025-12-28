class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.41.1.tar.gz"
  sha256 "68aab9ac99ccebddbc4d07993515a0568f4ed91df7fc4490a7c52c3d76068183"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91703e4cbef46bcad60365f51c4ee9ecbad9b03c9332f4ffa8d526cabbae9ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91703e4cbef46bcad60365f51c4ee9ecbad9b03c9332f4ffa8d526cabbae9ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91703e4cbef46bcad60365f51c4ee9ecbad9b03c9332f4ffa8d526cabbae9ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f24138c611a74bd85b20645e801dfc1d0bc91ee242e0e8c020391befc7c17e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2623756b4eebf961727d3b62a66b7b259ea1bdeeda085468c15ee9f38af42aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9dcc17de1b1f641d11d966f3142dad1d461b46067b82e79552a0c2c9190d22c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end