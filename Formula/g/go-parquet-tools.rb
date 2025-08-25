class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "0353326ad182ad41cb6924a98df8120684d562fb6e698f16c4b39318639b8490"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15cfa2a52a9f666926f464c0ac1956a341faea7eb00d694f124cca2b0599cbcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15cfa2a52a9f666926f464c0ac1956a341faea7eb00d694f124cca2b0599cbcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15cfa2a52a9f666926f464c0ac1956a341faea7eb00d694f124cca2b0599cbcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4321933316142c31bd3b5dfaee43cd36066488940cd6eacc0f1826284f7fffe4"
    sha256 cellar: :any_skip_relocation, ventura:       "4321933316142c31bd3b5dfaee43cd36066488940cd6eacc0f1826284f7fffe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a07f3a3934f31a4af0d8769b47b2ab2da54da54ab1b684c4792650232c0776"
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