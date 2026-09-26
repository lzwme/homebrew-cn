class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.88.tar.gz"
  sha256 "0f42ae2640868bd34623c8e1d37c968481320f274cd60f259596119f85ce6a45"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a39f7d8f074a199421adb4558dd5ebd2f66cff354fdac3f3867427728c3c62c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75b17d78dcf357450b14325c224ddfb5f04bb793d9afeaa52e11bb41484f5e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "359e4232dc4f4a75927d8751a88331edafcee89a9e355b78ec30e91400b55c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b63e56c0a79f17d0d58c7b3681fb234faaba3c274baba43331ae48b8a1fdd0c"
    sha256 cellar: :any,                 x86_64_linux:      "8dfb7e020bbc853d47c72ec1554effb12b2bf56d7b0168164b8bc737c83ae9af"
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