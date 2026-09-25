class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.87.tar.gz"
  sha256 "34a03d32c6a681a8e94a51f08d41f6d41a50eaafdad7668c642cd5983dd44fa3"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d86ee3fd4c216e2ca015c2f054ea8cd275a016131511b7b6233767b27d67bc30"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d720a2951eb1f2945070de9ed1fb8eb6f4b1cee851502735dfb78e76569250e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7205a3c9a839a554abdcb6c953daa19b0a9b470f2a3257cd1b4729a1c0b3025c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fea74111453ea915ec225a5ad282dfec68920f7d42cc30375c976b5ba64c4b2b"
    sha256 cellar: :any,                 x86_64_linux:      "d42b7413dba0dae4a8aa06dc684e990751c9b6cac90347600683efd6ba801086"
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