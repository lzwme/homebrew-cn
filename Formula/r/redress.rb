class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.90.tar.gz"
  sha256 "e1ba6eefce734bdbdca4cc46bf2c0565b49417f3cec1fdbfec4d122975140644"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8212161185bec1952f4895c3d260a4fdd446902350f66e96001d7347024fd1ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88c891af67b532d39f3f6bc747492f5c108a6fffbca1e8c1ec80f28ef2a4b686"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "610f1056ab59288e1ed672bbead4ab9972d18d069826cac41820923282c4bcaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c06c56f7eb6b01fe1c7d52a7d3f532ff96a294327feb2c6452ec4909e906bd4"
    sha256 cellar: :any,                 x86_64_linux:      "3e44c7e3c181fd1b1767fc1418455230042e998c9107ed656264279b5922eaa2"
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