class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.49.5.tar.gz"
  sha256 "a9fb785972f657991dc35e297bb4e465180063505a0afb540933014691e42e46"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "708608fa3842799a7366b5184fbd6e8bc302c5813893f14eae4ec1ce3527a543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708608fa3842799a7366b5184fbd6e8bc302c5813893f14eae4ec1ce3527a543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "708608fa3842799a7366b5184fbd6e8bc302c5813893f14eae4ec1ce3527a543"
    sha256 cellar: :any_skip_relocation, sonoma:        "398d6fd3511debae920e2650e6cf17b8ba8dea4ea621986a1521214a98ca988d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "617dabfe8c5adc7ec7112bfa970c0e0d05277b2b55c2211241a0261e1523afe6"
    sha256 cellar: :any,                 x86_64_linux:  "790c79fd9d8ae0022b485cd546c7034f8b4d875bf1b06d55fd9a5d2f0a810f4a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end