class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.4.tar.gz"
  sha256 "eccee62c91089d34d7d6fd1c93ec56282cc9b53ec9b7c4cc486e20fd3290b08b"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2d947f0ee293b4cf98a219a835545b0c20c5aa2c516f4e82cd0db1bbb97a8b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d947f0ee293b4cf98a219a835545b0c20c5aa2c516f4e82cd0db1bbb97a8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d947f0ee293b4cf98a219a835545b0c20c5aa2c516f4e82cd0db1bbb97a8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0a6dcfb8571ada25202ece046f6095abcf2e5fde586c6f803d21a53802a02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411d7c3f7352e7a00f2d97d97f69e5cba061d8f3f579497da241911cba4339bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba4265d287ea61d5ce877df3ecda9a22b1a12419d257d7e0b6cd55a7689b020"
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