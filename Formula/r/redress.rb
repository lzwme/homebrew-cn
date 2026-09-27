class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.89.tar.gz"
  sha256 "d4a672fa848d5fc4be603c15425544ba3ed959fb9112d63a38c9ceeab887a4dd"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e727e2fdaf26c4bfad09e1a3d8c9aec84ba03f5654f9de58e2759f568abd50d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a09db4bc6443632f4f19f395923a5fe179baf8eb72de8050950849496808bfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9de909cf47977eafcee704c7d04868cbaa1eb4004f80d945e84aa621fc865dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e31b38a9cc5c02f553de3fb29ecca777c8c71a569932fe9b23213780f2ecb116"
    sha256 cellar: :any,                 x86_64_linux:      "7e90f57a491237fd405758ac54b1681af93514241c971362b668ea87a4063026"
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