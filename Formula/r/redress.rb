class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.92.tar.gz"
  sha256 "133d85077163d6f5c045f7a38f37d23367420af27b34ecaeb295b1531506d5e5"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a4fce4d6787fd1323c9aed47ee8c0cff5313bccde1a09f4090bd12de4ba85a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fdecdc08f5dfa0bebe63f9640f03cec226ad5f5527cd68a6a94d30c72acdfccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f65688d6b29f391822a5be720e5bea09a52c0cf39fb2a397907b6f7230ecc91"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7248d900f97adbd5bdeb79baefffe5f535f82cf8a74366793d77e7d66764fdba"
    sha256 cellar: :any,                 x86_64_linux:      "85b42e49956171adf2a37aa71d6695b806521a251db5b0c1381635df628fc0e7"
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