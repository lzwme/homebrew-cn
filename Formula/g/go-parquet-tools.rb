class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.46.5.tar.gz"
  sha256 "238620b379388770a668a1e3077d8f6a4e7ff15ce7065f5797e56d5396647938"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c158654bdb8ef3257a76bf803cee44cc83db7b5ff6c84bd2a345ee842ac4c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c158654bdb8ef3257a76bf803cee44cc83db7b5ff6c84bd2a345ee842ac4c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c158654bdb8ef3257a76bf803cee44cc83db7b5ff6c84bd2a345ee842ac4c19"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ee0391bb5904110cd1b824d231487c34da98de92208d058ab95a99fcad343e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcea40e6e1cb596a681d58e9d97db1659779c4bdf409ef53276f1ff9cd2b4b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b002c57a9aafa3ad40817ee4a03719f6e12ca68bbc67a114954bb5be17b898d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end