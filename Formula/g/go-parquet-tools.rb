class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "55399f0850ca639d7b4eff5527cbb2301a528b34dd2dfb4fefb441973467f192"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17b3e56161ff93d6218a8fde46c58c3655ed84071e5e7ac3f64a09b465ab8b4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17b3e56161ff93d6218a8fde46c58c3655ed84071e5e7ac3f64a09b465ab8b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17b3e56161ff93d6218a8fde46c58c3655ed84071e5e7ac3f64a09b465ab8b4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8119d3bda4b5449f65299682f7451c018076e27678067f088679927643d23366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6045079ee3b8d2060cff1f1a37bbde5ac5c2b0b73a13734ecaa8c378b440b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21a9a4ecb509fbecb1650a471e8b55341002f1b2ca6971ebafa5fc5ba713ba44"
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