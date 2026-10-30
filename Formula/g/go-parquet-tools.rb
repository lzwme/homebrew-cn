class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "92e863d763415d17ded0257cd5c05f712798c3a8b0394a68f155b8dff56882dd"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e8f83bd061c55ec6b774ac48c80e2ad246461bfc1d051e1da19a3384ba5ce31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e8f83bd061c55ec6b774ac48c80e2ad246461bfc1d051e1da19a3384ba5ce31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e8f83bd061c55ec6b774ac48c80e2ad246461bfc1d051e1da19a3384ba5ce31"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f1716adc1b3fa3046d74d00871b002cc29e776f292694e61181cb089cfad3062"
    sha256 cellar: :any,                 x86_64_linux:      "2cc56a229d43481ac7b5ac7be9bb76da3097b6abafce4f93835476212b29b22c"
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