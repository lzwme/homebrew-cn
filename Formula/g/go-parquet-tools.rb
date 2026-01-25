class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "233e34327b37f0202e044eef67220b9b9f9066f20b49556ef6cb7169fe07fdc9"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ab294befbd18bfa3a3c0643fbc3edf49b78d0ae634567b072131b6bf834243b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ab294befbd18bfa3a3c0643fbc3edf49b78d0ae634567b072131b6bf834243b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab294befbd18bfa3a3c0643fbc3edf49b78d0ae634567b072131b6bf834243b"
    sha256 cellar: :any_skip_relocation, sonoma:        "faf3690e526169ef7b2b12552f9a90f599867af25a616ee909bc44e3b57a1f08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "476fdf836b90ab12b0c8b5cefcff325549e6513150158af19844efbb396fe3fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38cb345b9ca5774a77644de2a1598909f7e4b88eb09aa294075740235e416815"
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