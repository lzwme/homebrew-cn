class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.53.1.tar.gz"
  sha256 "0c2df12f5f4bba52971b549439acb0c709d05952dfc05b3f9b821d9bc0f0ed56"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0adc7e3c760f6cdd20cfcaa0971a44861b3dfd1ff3b08021f86a47a392bf5ad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0adc7e3c760f6cdd20cfcaa0971a44861b3dfd1ff3b08021f86a47a392bf5ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0adc7e3c760f6cdd20cfcaa0971a44861b3dfd1ff3b08021f86a47a392bf5ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "840f383fda1d665efd44c95c615aca6f6cc2beb7de726236284a87a0801c81f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5efbb1fb7b184f02b63e9000f0113efa148b6373dd018f551b3db1e288becdfa"
    sha256 cellar: :any,                 x86_64_linux:  "221f0ad8a4e44f08ffb32ecd564fb82d3e755b5185f15d27320160b04851b730"
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