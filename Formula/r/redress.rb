class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.97.tar.gz"
  sha256 "49dab4b8e6e618b2b2648ae5f9b88b02c5972845d08280aa2a6be80f1414814f"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cad657e4619dda3f3103121fa84f54bc506b99af4bcb112445d171006c6f2f57"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca092d230e28fd49a44fd29a36344d3f7c5b82310e8fdf58a00d9399e13805bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "823f9c2e766ef1dfcb951a082bf65adde84a7fe81470e070028596c64a94fbad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "455b8ad90a8b0d47875bedf7a073042a83b035e3fcf91a7cdc818e16d3a9d1ab"
    sha256 cellar: :any,                 x86_64_linux:      "ed4f638357d1011cf507db9c9f62be6b7c886b2604ea523a233d4f38ffa4eda4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end