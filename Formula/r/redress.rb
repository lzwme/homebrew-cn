class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.79.tar.gz"
  sha256 "b64a0e371c67696245afbb0f14ef80faca5e5747986e3244f6bc8ffd06d202a5"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e033b8b318fdd88246d2242b25f62264e4b22bf79a5956a0338f82012f15d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a349ec7cd3984677ef74b9764538c2dd8dc5d3479f0cf9e43c35894c81555793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a7112205caa1155213cf1d9f453213b57f004e9c307b6185151dc0883d079c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2926389adebe131dbf4e730ec0f7fed8c819ba6fcff717d5fd84e45d939fa32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "562559b71afa87f13e4aa4afe55ea73b27fa0a8900f8e63a554a7c2a2858241e"
    sha256 cellar: :any,                 x86_64_linux:  "cfc1fe4a63a0ca4d499063b544c1c7dc2f02b1edf72d5645b90f0e47d3c49f30"
  end

  depends_on "go" => :build

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