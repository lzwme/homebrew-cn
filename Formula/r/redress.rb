class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.96.tar.gz"
  sha256 "39c71f1b2e056a117af5f6a73c00cbe35c3c2be9d9cd82126807ef664d99e5c0"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0296af245dfb64bfdcd0dfa9acb4b26de7bf074176b9ca7c8f3fe5db4c5a3fdd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c4b1ef6f62f7f6f9f10f7a2ff47f29550473e434d3dbded60b8e11c5bcb7fa7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "993e9d0ed7c0b74fa1e40e1dd50db00f16adc97098e84597314f5eb1ea7b154d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21e0486a7097f9a008cf0327d4d78d0003bd308da7989495821ee0981793866d"
    sha256 cellar: :any,                 x86_64_linux:      "063cb6c04e6294708d41e5d26463316139fb7fb0674311f60e99f7ef19a555c7"
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