class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.30.tar.gz"
  sha256 "b47ecbe9f369bc2d6d3156542e1b4fa5fdb05e1d4aa239ce48d639a23d3440eb"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db042e76baaeab116e5abff0394860ee67427bc1e263e98ea051c0f7ca6edcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1db042e76baaeab116e5abff0394860ee67427bc1e263e98ea051c0f7ca6edcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1db042e76baaeab116e5abff0394860ee67427bc1e263e98ea051c0f7ca6edcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3537192e344b0dcbd28639e6bdd624ad2db78538aebf6cca885b697db3913c75"
    sha256 cellar: :any_skip_relocation, ventura:       "3537192e344b0dcbd28639e6bdd624ad2db78538aebf6cca885b697db3913c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6581e480f4d73a96d64b16e34eba41bbda3a64d9cea44bdd8cbdff75385bccb5"
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