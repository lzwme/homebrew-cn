class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.28.tar.gz"
  sha256 "f8b71c74ba52b8c16055340fa4934104f8cafc0443c08242fbfac7e626e18bc6"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d295c30c2aad02866e239c0565f43ad8c51389ab23cf87d519d2de6964896d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d295c30c2aad02866e239c0565f43ad8c51389ab23cf87d519d2de6964896d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d295c30c2aad02866e239c0565f43ad8c51389ab23cf87d519d2de6964896d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "72cda05b6c19a3b34376606d33cba25b0f29191d1553a811ba84476fe86bbe30"
    sha256 cellar: :any_skip_relocation, ventura:       "72cda05b6c19a3b34376606d33cba25b0f29191d1553a811ba84476fe86bbe30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a295f91a0fc9a598a889b2fbc24ac1ca6c85e7bbda95ce92e24ecc2221042e"
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