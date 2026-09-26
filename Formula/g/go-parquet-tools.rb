class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.55.3.tar.gz"
  sha256 "69504539c6c592cc69e507da95e87db6ae0c8f939d7ffe9e3bee89e0a601a4bb"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19cc286de03ed02c17e40afc3bee0cca1d5b1365622a413742c52064a0eba47b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19cc286de03ed02c17e40afc3bee0cca1d5b1365622a413742c52064a0eba47b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19cc286de03ed02c17e40afc3bee0cca1d5b1365622a413742c52064a0eba47b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d615d2d37d22095cebd06ebc9a637b217aad24dcd2bc75ac9f0d9f68764b50d"
    sha256 cellar: :any,                 x86_64_linux:      "2740bf11daf1a0cbaa04e58e10f527913d11029e7d6b0cb579b4d9422a5c3411"
  end

  depends_on "go" => :build

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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