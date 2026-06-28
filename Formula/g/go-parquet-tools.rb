class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "3a26ee3b3110f74bc49df5affe0b9f7908293c50cf4f114f1726caa985a996ba"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ff67d1a0a95de7f4b5337c34f2243f0998a09573b881c2dc7e64b45a6171925"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ff67d1a0a95de7f4b5337c34f2243f0998a09573b881c2dc7e64b45a6171925"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ff67d1a0a95de7f4b5337c34f2243f0998a09573b881c2dc7e64b45a6171925"
    sha256 cellar: :any_skip_relocation, sonoma:        "453898bd942fe39bcda9cf8ff9e8084880c818879ed6a82828140f1c4c46008d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc4e53781817a2d93fbc7008bdbb0054bba320abc7c94aa0a02e5b8f7fbc26d8"
    sha256 cellar: :any,                 x86_64_linux:  "206439c46c1d36fb45ef017e259f6b9f5692d187255cb60eb4da388aabf58acb"
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