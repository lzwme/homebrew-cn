class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.2.tar.gz"
  sha256 "7a2c5f0d63ee402bcf0b6399c164db650e8ec705c89561398a32a39323ab3920"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2753a23acfe3a28f4e6f7edde9acd666340342eba50dfbb0696c0f11c8cf0ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2753a23acfe3a28f4e6f7edde9acd666340342eba50dfbb0696c0f11c8cf0ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2753a23acfe3a28f4e6f7edde9acd666340342eba50dfbb0696c0f11c8cf0ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe966978613d1886c097f91e87c89a95d5cb76a1a4ed474ea7624794b9e58cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8468421a0f87cdab5e63e35922aee53639e99ee32655df116913f42380cf36fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105f1f37c23ed971b06385dea08dde0ac694c584ab3bb823c13504fca7dddaed"
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