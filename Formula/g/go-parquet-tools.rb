class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.48.2.tar.gz"
  sha256 "c7349bcdc3aad4b49fa8a6b9072415a44953c123deee04d8f42022c51c156427"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "020daca0f3a925eaa5e672f9f602d1e813b822a4b3e928646c1fafab56710e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "020daca0f3a925eaa5e672f9f602d1e813b822a4b3e928646c1fafab56710e0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "020daca0f3a925eaa5e672f9f602d1e813b822a4b3e928646c1fafab56710e0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "752a01bf17070663dcff6ae9af8f12ef38822a86a5dc29f02968514b7a3a8769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "320a28ad463c2dfa82d5207439e2837038eccaf6ea45c00fae354356bd36713f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6253980ebbcf6b1464423bf04702e094ee8998edf0de0c73b4d5281e46b1e5e3"
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