class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.32.6.tar.gz"
  sha256 "d0e50c666e45df1f2c66218fb8391943f9c3188078b9f6d45e479a5cb5d03477"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "284d07c2eb404be14418ded59c60d6099dc3199c76842cfba64973f62f548875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "284d07c2eb404be14418ded59c60d6099dc3199c76842cfba64973f62f548875"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "284d07c2eb404be14418ded59c60d6099dc3199c76842cfba64973f62f548875"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ac850cfab7f48d85d76980b58297d98a47fbe8841645ad60b18badbe01e95e"
    sha256 cellar: :any_skip_relocation, ventura:       "74ac850cfab7f48d85d76980b58297d98a47fbe8841645ad60b18badbe01e95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1992d6d60451f2d0da28b6f7c8a854a1b244a0226af86f0404f1b295c3668617"
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