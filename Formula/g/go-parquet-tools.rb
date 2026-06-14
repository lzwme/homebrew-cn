class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "b14af8c3c92423cb994cf2a95a7c7cea8c14064665c4cdd7180b2914d2adf4ed"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e96e674ec07c7bf32b08dea28fba8da69adb0108b3b64329ba1c2b8cf00cca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e96e674ec07c7bf32b08dea28fba8da69adb0108b3b64329ba1c2b8cf00cca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e96e674ec07c7bf32b08dea28fba8da69adb0108b3b64329ba1c2b8cf00cca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d5b168265dc37ff0e20d1b3f27e0f17b43188c8a944a806afaf481cc7572998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58f98f6bf705d2155e57bd2da53d891cb669c09b69b2fba2af8ff767674acb8b"
    sha256 cellar: :any,                 x86_64_linux:  "d6ff171a0946b37bb93cdfc269bf85de14c894077e69bc2ab66cf6fb6942c97d"
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