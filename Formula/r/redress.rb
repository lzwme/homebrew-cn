class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.50.tar.gz"
  sha256 "5404489a639fc855ae46b9df343d2a80e81f596832290561eaceac8447d7f3f7"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61655cf409d7ad65eac14dd2b6223c2985d7de1334991f1c5a2616f9d7e14c10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be18a8f568910618e683d1dfdbde7f2bb1e1ab629bb6aa96a5f699f37b01a80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02779b0c846c84ff655351f4a2f6f579132217b55491abf20e70c6706c80bd10"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bebd65ae17436143db70601824a072ee0c896c047239905ea57b176d91b51f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "324cfad0e810f3ec4c02b7a698d71ea6f146e2e02ae893ec3ec48321da846865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4dbdbb9fb7024da550c7af797ceafc1d7876c116af0b2802c53af2d77b4842d"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end