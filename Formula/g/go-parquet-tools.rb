class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "9ae12b505223fa5657cef397d9404e2fedfd189c1b07a010dce8830a73a90aa1"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff92d55ad1989f706438758f75492c85a2e53ab892f8ffa7f4239cc56202a177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff92d55ad1989f706438758f75492c85a2e53ab892f8ffa7f4239cc56202a177"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff92d55ad1989f706438758f75492c85a2e53ab892f8ffa7f4239cc56202a177"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b5096e395c65c77ef8ec9722d108a7d5c765bd110c04bd9b05e6395702e1e00"
    sha256 cellar: :any_skip_relocation, ventura:       "3b5096e395c65c77ef8ec9722d108a7d5c765bd110c04bd9b05e6395702e1e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10cd557107d96a41b921411fb14173fe80becba62aa17f98aa16b61109c1727e"
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