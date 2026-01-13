class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "277b32904e63e29e9ea6beda08b8ac318ca5a8cd359501cae41e858842822f32"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36697a2fc148cae4ad456521dd3285866acc9598196c83c93c9bcf39dba4fcd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36697a2fc148cae4ad456521dd3285866acc9598196c83c93c9bcf39dba4fcd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36697a2fc148cae4ad456521dd3285866acc9598196c83c93c9bcf39dba4fcd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbb58442175131b3c210921815feb842463f5d188d513262a38552fe415006c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640c2f67fd781bae824542ed5e9cb710d6d1abbaf754474353c0ef873e1b7400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04cfdaa7c2bc866bf86304b1e3d77fcf1c0df16ec6eb10e185a237bc9fcd9ec"
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