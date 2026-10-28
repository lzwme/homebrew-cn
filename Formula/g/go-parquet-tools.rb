class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.56.5.tar.gz"
  sha256 "12f99825ed3ef6647079f0ece4bebe105fe082a454e4c1b647e238f2d102035b"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a99c6e4abe960a574be19e146a1e7d3a174859d62a5bc4be2085d0b26bd2aaf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a99c6e4abe960a574be19e146a1e7d3a174859d62a5bc4be2085d0b26bd2aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a99c6e4abe960a574be19e146a1e7d3a174859d62a5bc4be2085d0b26bd2aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c19439d1d88997016aa415ad0717cda0639fe9bc4435889f5cc02c8af449903"
    sha256 cellar: :any,                 x86_64_linux:      "0868a5cac41257edc8a6fa082f151a831c0bd9dde3f1bdf57ff7861fd8ba36a6"
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