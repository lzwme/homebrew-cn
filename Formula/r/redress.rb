class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.94.tar.gz"
  sha256 "267d9253a12b035d7505a21cf9425d19a5b825477914e352a6974c58f6129da2"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5f00f8b58eb3cd8d94065b4441e30c075269487d0e663891c5dfb0426532d0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12fccfa95773827eb937f4be98a9eadc7a95eb3be80cebfd1a830ffe13d61769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17e48e15d9130db42075cc2edba3bcd32766bf95dc399242cb1a91998720a23d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "432b2435341d0dac7901220c4b1dead057bb0d7648ef67e494f3dd5b98514210"
    sha256 cellar: :any,                 x86_64_linux:      "19efa4cefb882f1607927d495bf27d8b508dd1af88d7b9a707a2b2e1cca02845"
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