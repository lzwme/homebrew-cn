class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "47573c8d57bcae075654fb6da927f4cfce28babf25b7069a30908de10f5030d2"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2d9692c5b2893277f98942701cc74ce224a5a4609e295436326e234413602b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2d9692c5b2893277f98942701cc74ce224a5a4609e295436326e234413602b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f2d9692c5b2893277f98942701cc74ce224a5a4609e295436326e234413602b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0f8b0eaa41779e6eb5eccf48e2ab28465750f719551404c45e74f7609efa5ae"
    sha256 cellar: :any_skip_relocation, ventura:       "d0f8b0eaa41779e6eb5eccf48e2ab28465750f719551404c45e74f7609efa5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e4232c6201312fd8db00e04d9c1a579770d2a0cea4eb634660abd1f0624854e"
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