class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.44.2.tar.gz"
  sha256 "0d028a849a28b34969322f749fe8600d13533cab660985e6352a77c5719f902d"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "045edf646f9956fe799c3e0f1a644b0d6aa0afdf5ae71a212810584b69cb1772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "045edf646f9956fe799c3e0f1a644b0d6aa0afdf5ae71a212810584b69cb1772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "045edf646f9956fe799c3e0f1a644b0d6aa0afdf5ae71a212810584b69cb1772"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2ad8ccbbc6b909ec422c738bf63235580d559ab33706c8a1a84f8af4b47d7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b40918c2717801175f80ff436e949b0b67c1ba02ab8ac41daf0ee58a4225b1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9ad6de5f5332fa4e3f3ff61acab3bccbeb7a966097a83b8bc095e9d79fb11b"
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