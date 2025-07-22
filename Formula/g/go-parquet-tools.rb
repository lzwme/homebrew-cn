class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "aab0df5177bf7678fa4ea039a0f0a879c46e300c36b3ae1f9b5c8188b7c32ba5"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48fc5e969bd9bdffd315decff2b442507164d011df12825148366857638fd02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d48fc5e969bd9bdffd315decff2b442507164d011df12825148366857638fd02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d48fc5e969bd9bdffd315decff2b442507164d011df12825148366857638fd02"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee13283a40f59e6b1be4b2954d83e45f45022a2bc72634d388a21ae053dfac88"
    sha256 cellar: :any_skip_relocation, ventura:       "ee13283a40f59e6b1be4b2954d83e45f45022a2bc72634d388a21ae053dfac88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75d24b963899d4a20170e45c69fa86f31a68fe3b678c681ebe623050e08db3f8"
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