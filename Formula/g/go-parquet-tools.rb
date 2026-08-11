class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.54.2.tar.gz"
  sha256 "18670e71d25d3899e61d659c6c9f101827562ed32f28e0f9b5da381cc0966337"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c014b54a64f56b11e7a544bf5285d13bba27695dc34fd55748fd5233a3e6d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c014b54a64f56b11e7a544bf5285d13bba27695dc34fd55748fd5233a3e6d19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c014b54a64f56b11e7a544bf5285d13bba27695dc34fd55748fd5233a3e6d19"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d2b40ff9da6678b207d4b9ebd97773e16f630e98c31de7d89c962aa06db305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bbfcf216c6383cc4049b6df0073a530d3f8bbd8cb77b933cac18ca784d6fd11"
    sha256 cellar: :any,                 x86_64_linux:  "2421ae1393895864434fb68dddd23b2a76de21ae41f4cc8c11a2cdd17e3f1a4f"
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