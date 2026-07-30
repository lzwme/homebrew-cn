class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "7791a8b95020397c3b123c2ae4fef78c4768d26386d0c964523e0ca6c1df52f1"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc626f6df891e8f7cdfbff122d5ea3d6d45977a51a036ad466d2d4915c41ff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc626f6df891e8f7cdfbff122d5ea3d6d45977a51a036ad466d2d4915c41ff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc626f6df891e8f7cdfbff122d5ea3d6d45977a51a036ad466d2d4915c41ff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "239ae0ee76ce7a0dc0c226f059bc8eb0ba7f3081291ed1b695855fca0969773e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd1b607816d28580d4f0abb8ff003ebe7459bba27756d2ca5a55bf038e5fd59a"
    sha256 cellar: :any,                 x86_64_linux:  "3b95456774a900f34311e118f67a5c323b77950f614a5c06c9a559bf87b91621"
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