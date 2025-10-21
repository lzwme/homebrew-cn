class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "55f68f282a9f8b002e0491464685a1e747fe4bd422c540118c15993264177a13"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4899bb6eb326cd351a118709d9301e1df8f5a1d9a76b1f73e7abd8f68ad14ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4899bb6eb326cd351a118709d9301e1df8f5a1d9a76b1f73e7abd8f68ad14ca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4899bb6eb326cd351a118709d9301e1df8f5a1d9a76b1f73e7abd8f68ad14ca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac3663649465308e57ec569320cdd8ffb5b0887fcd043504a4dc1fcff1dce0e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76ff4f59d89c4d3deeaa57a6ddbfaea80636d983cffa9203f9d6fdcf346fed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6453d17be9a27fee31ca260c1ff44d073515aec2dac6c451ee49b9dc0cf3d9"
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