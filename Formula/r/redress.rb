class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.38.tar.gz"
  sha256 "bc344372bc9643857f79721e2493eaabaf291b31751463ba6c100b969f5bee2a"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0825776df4a8e3f73ace96b3743698741b2ed05a97376ada1192d4efb82558fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0825776df4a8e3f73ace96b3743698741b2ed05a97376ada1192d4efb82558fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0825776df4a8e3f73ace96b3743698741b2ed05a97376ada1192d4efb82558fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5e39e207ff98a6ed6057bec387dfbb58ca95b53fda6c0c653c1de55acc41672"
    sha256 cellar: :any_skip_relocation, ventura:       "f5e39e207ff98a6ed6057bec387dfbb58ca95b53fda6c0c653c1de55acc41672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcef32f4ff8599605fdba0d6888eac1d84badad437f43ad820b6125cda7d9a5"
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

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end