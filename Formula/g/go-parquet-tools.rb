class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "779e2c108ac986e50c1583ed570ca31eaebe719e38a6363ef47ed39547f009dc"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c670ae0a04b789f5221fcdff5b324a84834750d435f30a07e88713bbb6dbc25e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c670ae0a04b789f5221fcdff5b324a84834750d435f30a07e88713bbb6dbc25e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c670ae0a04b789f5221fcdff5b324a84834750d435f30a07e88713bbb6dbc25e"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e93bd973eb34c149ae72933f3244f9c5a581ec003cab82943456416b716605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09053ebcfe35edfed465078ad9961319d86d53efeb438f69697d60f614f0979b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51eabae90e1766de5501f1857a87fabcfe2804c1e21437c9e3c14e5baa843740"
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