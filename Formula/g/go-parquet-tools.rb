class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.54.5.tar.gz"
  sha256 "2bb1899cbecaa2c5e8a6f749af94c14b2874d52c26400c68627864fb836c8140"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e892e7981104756aa3e8240f110e1fdb1c97cd63dd224f370525dc1760aecd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e892e7981104756aa3e8240f110e1fdb1c97cd63dd224f370525dc1760aecd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e892e7981104756aa3e8240f110e1fdb1c97cd63dd224f370525dc1760aecd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f51bb48256a4464053f0fc0f719484d0e6aeabc0b44689871d8cbea67d74581"
    sha256 cellar: :any,                 x86_64_linux:  "9bd2eb998cc96543b662182cec8783be98d0c659eae4ab405ea65cec253da874"
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