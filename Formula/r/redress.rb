class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.23.tar.gz"
  sha256 "ef483a24c2d47502f24d655653812d6f0989154541c95badb8b893d7dce57bff"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0777237800222903e925ddf221b7ba51d3ddc6bccc94422f4d91f54f0b46eab7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0777237800222903e925ddf221b7ba51d3ddc6bccc94422f4d91f54f0b46eab7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0777237800222903e925ddf221b7ba51d3ddc6bccc94422f4d91f54f0b46eab7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dbe715f8a128a76654978d4d45e4275030633c2b69eef2eef2b51d3632855ff"
    sha256 cellar: :any_skip_relocation, ventura:       "3dbe715f8a128a76654978d4d45e4275030633c2b69eef2eef2b51d3632855ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741f6d433e1844a9e943f34d902e8bd79c4fc1eaa4d1f7950b0daad819b3d738"
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