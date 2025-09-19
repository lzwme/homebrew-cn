class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "af31e4b95e701cf93c2676454da0c6d7fb69fbd2e9f76a5b8d6993e432045a13"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ba3c75b7bcb7d439b86de7f6ef9a31cead90df1a88ee7ca6a78de46a986912c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ba3c75b7bcb7d439b86de7f6ef9a31cead90df1a88ee7ca6a78de46a986912c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba3c75b7bcb7d439b86de7f6ef9a31cead90df1a88ee7ca6a78de46a986912c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a207d35a8efd8cb03867cf7bf9f090e431e9fe2a3d095a878bc803132e196860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f130247478ab5a05522279690a15349ebdb7de6f8855ac890b11d8eacead8944"
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