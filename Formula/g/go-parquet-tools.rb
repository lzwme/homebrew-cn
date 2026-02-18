class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.1.tar.gz"
  sha256 "0bb8e908b0ece7b8a16e96fa7126218888c94243c7397d4e12bd3aea623ce9df"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0851f2e9288a58f7fb153a24ffdef1216a4043d22f5fa28b659e301c4749b19f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0851f2e9288a58f7fb153a24ffdef1216a4043d22f5fa28b659e301c4749b19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0851f2e9288a58f7fb153a24ffdef1216a4043d22f5fa28b659e301c4749b19f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6c90517333625876aa873ca93d24e76c09e8770eedbdc96c67946aff880a259"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f531849a66bff96cfab9c9f858c9a59a998e9c70a7a1f7043e6b49164975c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e62ae0090330e0b0f0216c37983f39cde548355057d2dbe7291eef4f2a26592"
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