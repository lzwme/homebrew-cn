class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "c39cad0dfc9d16b9fa0dfd0cb1387b692c95231df1b405644a513c39d76cfd14"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9a4bcd5f0b7f788f75aba83c8e4638d1bdc2a32926f5e90e66fe258ecd94e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd9a4bcd5f0b7f788f75aba83c8e4638d1bdc2a32926f5e90e66fe258ecd94e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd9a4bcd5f0b7f788f75aba83c8e4638d1bdc2a32926f5e90e66fe258ecd94e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "49a9bff38e51aca2e0c886935e406880a1002744d645de8cb48999548116550a"
    sha256 cellar: :any_skip_relocation, ventura:       "49a9bff38e51aca2e0c886935e406880a1002744d645de8cb48999548116550a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1503480b50cfd00fc85291c1d27e0c9c0d68ee3b1a08b8ae70cefb4b0d2b5518"
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