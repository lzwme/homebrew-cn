class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.95.tar.gz"
  sha256 "d6e9ccded098ddee0431d34b72e7b2cbc9265d050c472e453e5834a2ed554cc9"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e45d3150e6e2b5ccabb943203c25f9671d1da8589c42d459aabb5fbb5cf373d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "135ec23f60512c755e5e3fd45eb89dc9d781133175bc6c87058bb252d49984b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "187f1c6a50570e41d4e127c7740f3da73a0cf8884ac7eaf8578b00e15431687b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "090a05ce7e31d555241261ec8b97a3a50a813900ee122fd994dc291faf34caf3"
    sha256 cellar: :any,                 x86_64_linux:      "b5a805647fb4834cf79925617f28a46d9a7fe8d38b05ab0b0533ccc311ff460c"
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