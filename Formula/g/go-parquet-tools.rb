class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.54.1.tar.gz"
  sha256 "cc830b3bb31ed46fc3d6dd13d64d4c4bff7ae7be600ad44cf7651560a7c70676"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "023b4330c66a540f00aa322d293972efa304685c602385c5d3102d8c41c69792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "023b4330c66a540f00aa322d293972efa304685c602385c5d3102d8c41c69792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "023b4330c66a540f00aa322d293972efa304685c602385c5d3102d8c41c69792"
    sha256 cellar: :any_skip_relocation, sonoma:        "768fdd70887049276169d3cbe2513b8e7f8bfeb42437be7bb2fe699ec40dccaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b56177cbcc52962165a82ae9fb8b83cdeea1b4c85fbf987372ab077f0f0f207"
    sha256 cellar: :any,                 x86_64_linux:  "3722b4744215743a62fc5c67d8ccad8511677fbba03192488be08a5e3cdd17b7"
  end

  depends_on "go" => :build

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