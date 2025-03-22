class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.22.tar.gz"
  sha256 "526420e7dd39f27d4f0a58fc40c5607af1c0dd04ffc0686dcec7ec75f0f2edd7"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4513c2e7d34b4e3ea513514ba54ab8fb1c089e0e90dd08255776ea06e7597aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4513c2e7d34b4e3ea513514ba54ab8fb1c089e0e90dd08255776ea06e7597aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4513c2e7d34b4e3ea513514ba54ab8fb1c089e0e90dd08255776ea06e7597aac"
    sha256 cellar: :any_skip_relocation, sonoma:        "151818a2feef3cef28600e2c8563f84adb79f0375157dc81191778908571571a"
    sha256 cellar: :any_skip_relocation, ventura:       "151818a2feef3cef28600e2c8563f84adb79f0375157dc81191778908571571a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "690f6c04a78c56242b5f916697f7149580686b2af2a4accfd513cb6d4e7541cb"
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