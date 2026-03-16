class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.8.tar.gz"
  sha256 "407c07dd75dac26d1226d807332668331057c0acb61614b75748a659c17dade3"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "735964a37e858a6a49850304a1e3a56e1ba2e920d4655c65b5b3a264433a4eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "735964a37e858a6a49850304a1e3a56e1ba2e920d4655c65b5b3a264433a4eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735964a37e858a6a49850304a1e3a56e1ba2e920d4655c65b5b3a264433a4eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df53574d6f33507f3f80c73cffbf6e1bcbd06aee57438aa9021946f4bc0c106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66866382674343e27c4ac299b2f42bd8b19de5731d5ed83fbc0308db52069706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c806b1b5b6d37b3ffcd51cbe904496e8c48a2770719779eba2a478a73b3431"
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