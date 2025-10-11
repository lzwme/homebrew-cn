class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "4bc7fb0eceac4a595768977681a64b478e0cde1c13993dc09d587dd9db28d941"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b56dc9a94cba6febc16638230be4ce69aa386eab3f5dd97a20d79472a4f984f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b56dc9a94cba6febc16638230be4ce69aa386eab3f5dd97a20d79472a4f984f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56dc9a94cba6febc16638230be4ce69aa386eab3f5dd97a20d79472a4f984f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf842f0843d77dd078dc3a8beeddefeaf0f4f0d147524414796b38a712ea420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0f2e23ea9ad878cb87e0bd4b60e9dd79932939401497ff7e0e5624ddc422148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c1a7e33480f54c6c97fd220f94c8651c9d82a0f0c8e2eb58be33b50e8ae259"
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