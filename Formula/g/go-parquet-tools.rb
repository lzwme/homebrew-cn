class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "4556e0cb23f9c4707ae4218096c1f9e7dd91966789756567f5203f5c25c11b3c"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "50f5ccbeb8f7e7a8fecfbbffd8e9a8979fa73bae88c0447b38474e30eec784e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50f5ccbeb8f7e7a8fecfbbffd8e9a8979fa73bae88c0447b38474e30eec784e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50f5ccbeb8f7e7a8fecfbbffd8e9a8979fa73bae88c0447b38474e30eec784e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0a5d2d51d21d268f13583ecbda80427cfdb881bb658c6eab8f8544c661bcb11"
    sha256 cellar: :any,                 x86_64_linux:      "05204347f47cda30543d65dddf1e1b01414403e75ef2a9139af5db8196d6f13c"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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