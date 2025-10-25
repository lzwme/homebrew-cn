class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.43.tar.gz"
  sha256 "4c817f24c151ff9ab8c9f8bbe2ae8ac75ed3a26955806ccc2dbebe5e2dcc8dcd"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6ca3ca00cbf90c85ba7aad0b53f43b9e5e43cb1e3d0d9a3122832b924e6b366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ca3ca00cbf90c85ba7aad0b53f43b9e5e43cb1e3d0d9a3122832b924e6b366"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6ca3ca00cbf90c85ba7aad0b53f43b9e5e43cb1e3d0d9a3122832b924e6b366"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa302d9a800bf3ae15582c0dc3c4852d4c914b3f2e2c2a79629fc11987585dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4378d7427f9fa8f96869dc78365e31dd731c045dcd6124d5b4c3b4cb00b09043"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984da666e9c01a661ce3347e36821b76c5af5f8477c4f68c0acfc00988c1daa0"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end