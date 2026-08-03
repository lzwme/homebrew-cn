class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "286f0047f2c98ea97dce58676725fb053bdeb2ee03663593d92df010eab55c7e"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d863fd9cc08bd1ebcb5f7c95e04486b5e9df83d2f87d5838438c615d62061b22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d863fd9cc08bd1ebcb5f7c95e04486b5e9df83d2f87d5838438c615d62061b22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d863fd9cc08bd1ebcb5f7c95e04486b5e9df83d2f87d5838438c615d62061b22"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e485cdc1b8bbe0b7f38cea5bb77666545b6ab42e214c7aebba63eaf5d5cfcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b92f0d1e99682f38f9e9edd33701e348939a36ccc083eaf548b7b0f2aab86c77"
    sha256 cellar: :any,                 x86_64_linux:  "eda5ef88099aeedb02a019371d7e90eeaadad3506da913f7f60fbfaa52c0b6a7"
  end

  depends_on "go" => :build

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

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end