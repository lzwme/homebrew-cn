class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.35.tar.gz"
  sha256 "5e5ff9a8c93b207572006ec94d2ec334ef40ab61c62a1ebd4ed15f7ba75ce8b6"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5680b8541e7b0092e33ee4b280bc69b8dd50e6e36202dd5b8e87f34a8dafeb24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5680b8541e7b0092e33ee4b280bc69b8dd50e6e36202dd5b8e87f34a8dafeb24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5680b8541e7b0092e33ee4b280bc69b8dd50e6e36202dd5b8e87f34a8dafeb24"
    sha256 cellar: :any_skip_relocation, sonoma:        "009d26dd0e110940492e347b55f34d9571ed1da47a8708aec8f4b306fe332007"
    sha256 cellar: :any_skip_relocation, ventura:       "009d26dd0e110940492e347b55f34d9571ed1da47a8708aec8f4b306fe332007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a38f89849c97a0989127b4d9c67bf31f6d721d49e98e4e8cc327569fec037ed"
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