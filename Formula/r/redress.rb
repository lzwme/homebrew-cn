class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.16.tar.gz"
  sha256 "4d5c264944fb4d0b035541abd82f02390bd518e320303c158d0d9bf1e3e88c21"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71751ea4ea6e0b3643f6f310d14367f2d571412dcdb0be1427d21ca14aa0cc3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71751ea4ea6e0b3643f6f310d14367f2d571412dcdb0be1427d21ca14aa0cc3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71751ea4ea6e0b3643f6f310d14367f2d571412dcdb0be1427d21ca14aa0cc3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae52b0004eaa32319e49a0bb6acedc4fdca0a33e6668d16dafcd7f5e9e193085"
    sha256 cellar: :any_skip_relocation, ventura:       "ae52b0004eaa32319e49a0bb6acedc4fdca0a33e6668d16dafcd7f5e9e193085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d00f5d541864c38e7769cbdde439d29bd71b6ab92bb0e9d33d4b79ebf78ea8"
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