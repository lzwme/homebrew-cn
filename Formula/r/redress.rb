class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.91.tar.gz"
  sha256 "1fdf67f6c8a001a22d879ff04f8ee24e59b59c65cbacc9c5e16d992264b3e53e"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86fdff7bbb076f2db4557d7f1f98543332e71d07165696cb5a049a70793b0b55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d873e8b0ffec4a0385ddd4429f9038a14e4277c9898bff9fe30f91d83e6d7c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6934e41e2ab4566dab431835e73e16255fceb6737bb37d04ed5a9358cad1d241"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d0d91ac70f9d7f16278c9ce1e9c07c2be77306727c063e4236e527e475b2ca6"
    sha256 cellar: :any,                 x86_64_linux:      "58d7c6aceece504f2b46d180a972fdbf6cc9cc42fcce1e266cc44c52de203275"
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