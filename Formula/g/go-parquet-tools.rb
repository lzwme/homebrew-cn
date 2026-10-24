class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.56.4.tar.gz"
  sha256 "3dd831d8e618f102bbc04341e1753a663789abb6f2d17ce6dd5b964ef25ae09b"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cb6ba2ffcb259f248dc0089236888f589a74ae9008979718ff270ab35ee48b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cb6ba2ffcb259f248dc0089236888f589a74ae9008979718ff270ab35ee48b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cb6ba2ffcb259f248dc0089236888f589a74ae9008979718ff270ab35ee48b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8579e5584a06c437577ec5ce00c00d548907d5a149f4f450f1fe6bb6ac2d189"
    sha256 cellar: :any,                 x86_64_linux:      "d3c6289e23a5109704de28d749d2c5f140ca665f43470d41783b4251b3d9ba76"
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