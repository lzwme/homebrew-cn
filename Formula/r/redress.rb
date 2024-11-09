class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.5.tar.gz"
  sha256 "6bc1ccaeb268df58f22b21808e0cd019feb9f1a53e6886079d2bd780cfb14ce1"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cea360628fa56726e20e7537a860a75715e4a6def5971999de28300c4af013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4cea360628fa56726e20e7537a860a75715e4a6def5971999de28300c4af013"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4cea360628fa56726e20e7537a860a75715e4a6def5971999de28300c4af013"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b603bf39fbb1e505d7cffea4a997cf96d3668ed07f822f484270424be7a4715"
    sha256 cellar: :any_skip_relocation, ventura:       "3b603bf39fbb1e505d7cffea4a997cf96d3668ed07f822f484270424be7a4715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740a8f7e503778b5aa32fb87b61817fb3ff5ebbceeee82b53f826ab2e6f3de6f"
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