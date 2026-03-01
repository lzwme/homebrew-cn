class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.6.tar.gz"
  sha256 "326513be00da3e4c9226da96c1a7e0b6a8b8ca017295ec529defda17fa2cebd5"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ff64332bd2ef4b2bba8be5815faa13077becbf778aa6290bb95114b1ecf4d8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff64332bd2ef4b2bba8be5815faa13077becbf778aa6290bb95114b1ecf4d8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff64332bd2ef4b2bba8be5815faa13077becbf778aa6290bb95114b1ecf4d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21037ea514ae5cd8938289529aadfa2d6b3d26e4638ebd6e022f9f3e3b2d66b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05a7a6681fb3db1a2de795ba748a1cb0bb019ce9c44e563312ac65ee4b500418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b20e500b5407cf03bfecab3b20aaf1a1c10c12e4e1a300f6d02c1a43311864"
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