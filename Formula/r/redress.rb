class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.12.tar.gz"
  sha256 "1a51dfc4630e4ca61bd5d90c656bc4db4a0a24472a95be96fac1d66b12657db8"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7cb876ca963b9d34c0a699d1bbb7f402766a820dbb589a0566282c1973e142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b7cb876ca963b9d34c0a699d1bbb7f402766a820dbb589a0566282c1973e142"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b7cb876ca963b9d34c0a699d1bbb7f402766a820dbb589a0566282c1973e142"
    sha256 cellar: :any_skip_relocation, sonoma:        "233e4b6d6a5f054cd5de36ef613ff55c1aa49caa90e33b7418c4532e7b08a4cc"
    sha256 cellar: :any_skip_relocation, ventura:       "233e4b6d6a5f054cd5de36ef613ff55c1aa49caa90e33b7418c4532e7b08a4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9165b197e0bfe6e0e7f202fe110353b38f673f5e7b704445afbecceeabc5cf"
  end

  depends_on "go" => :build

  def install
    # https:github.comgoretkredressblobdevelopMakefile#L11-L14
    gore_version = File.read(buildpath"go.mod").scan(%r{goretkgore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}redress version")

    test_module_root = "github.comgoretkredress"
    test_bin_path = bin"redress"

    output = shell_output("#{bin}redress info '#{test_bin_path}'")
    assert_match(Main root\s+#{Regexp.escape(test_module_root)}, output)
  end
end