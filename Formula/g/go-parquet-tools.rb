class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.49.3.tar.gz"
  sha256 "47004d65f733a9d4ed287d2309adfa00aabeddefffcbe0be74f9ee1de5ca20c0"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c5a0dc9c6ab56d86599daeb3193565882785bbacbab46746973e3c94c24122b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c5a0dc9c6ab56d86599daeb3193565882785bbacbab46746973e3c94c24122b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c5a0dc9c6ab56d86599daeb3193565882785bbacbab46746973e3c94c24122b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bf1fcd243d42e0dd9cf2fa7a82296eb79580ba767c39ac1623ef48c8142d282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20063fa0e02ba4aecf1420079f379a855cc7dbadf40f463e809e0ddd41dd1afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0aef34e61e5f4ab285d6d41193a18b3c4b5abc3ddb9f8c72908e384cab7d4d"
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