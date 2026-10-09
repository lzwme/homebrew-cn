class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.56.1.tar.gz"
  sha256 "43873952510a06fc5d1949382ef483432fb0db98312877f2d80cde6d2324e426"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0988f71e397ebcf4daa846d9f604d0aa149947b5fcbf8e845b46480b42f5b98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0988f71e397ebcf4daa846d9f604d0aa149947b5fcbf8e845b46480b42f5b98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0988f71e397ebcf4daa846d9f604d0aa149947b5fcbf8e845b46480b42f5b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58fbfcd1fb03b5faae06d81297ba9600913ad0f7e77366114ab12513b7bdc67d"
    sha256 cellar: :any,                 x86_64_linux:      "4e82824d9b0874f30a73baf58bd353cfebe78449faf418aa28778496692e7eb9"
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