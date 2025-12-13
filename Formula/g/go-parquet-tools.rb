class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.39.10.tar.gz"
  sha256 "1309d48af9f9266f501780717dd6a1bc46f7397f6a4f628942d7abad4f2365e8"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f06aecda2c5402781002a5244d25a0f0bd0ac8b0ee853ddfbc60199e7be9558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f06aecda2c5402781002a5244d25a0f0bd0ac8b0ee853ddfbc60199e7be9558"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f06aecda2c5402781002a5244d25a0f0bd0ac8b0ee853ddfbc60199e7be9558"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2e3260417fbf21e056605653b545bf0c5c11ed27b18ce7f1c60f98942af9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64f074a79edd134efbf1f69e0835dec65a145d2fcea0cd5cd343b382f9c743bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cabd31589cb515332691e005fc013d81e74ccdc1370d4a169293f4edddf136c"
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