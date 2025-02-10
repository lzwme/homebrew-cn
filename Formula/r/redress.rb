class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.13.tar.gz"
  sha256 "e532c42b7465e972b587545fbba80c41ef20038fcf677da7a0032f7f5b7b75a2"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deded8b3a472461adc3a667ab5f53dc3225e7e10f3ea676b6c3b741c01211c01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deded8b3a472461adc3a667ab5f53dc3225e7e10f3ea676b6c3b741c01211c01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "deded8b3a472461adc3a667ab5f53dc3225e7e10f3ea676b6c3b741c01211c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e78e9451a22cd811357c39af5f472956f6e9ca01b98ab90735e0d0fa20f02a"
    sha256 cellar: :any_skip_relocation, ventura:       "70e78e9451a22cd811357c39af5f472956f6e9ca01b98ab90735e0d0fa20f02a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f12547b59a7d60372dc5ce4bbb0409cfdcf249d1244e2bc4cc745716a79e13a5"
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