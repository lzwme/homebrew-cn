class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.56.2.tar.gz"
  sha256 "102fe448bdcc1431792685987d517bf11822b53ec4effb15a4baf137319225bf"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d701613b8a3eef46d6898f5ae9e66ec8a933ad4e441aa581389522c34e6b2f7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d701613b8a3eef46d6898f5ae9e66ec8a933ad4e441aa581389522c34e6b2f7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d701613b8a3eef46d6898f5ae9e66ec8a933ad4e441aa581389522c34e6b2f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9372cc73fc745a7e98291793bef1ed8b2be4a3000165fb4cacd467fa8f70c5e2"
    sha256 cellar: :any,                 x86_64_linux:      "fa6db22f1d2b15871969e45f782d468be5af84cc13490832f9a6f07161affab9"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  resource("test-parquet", :test) do
    url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
    sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end