class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.7.tar.gz"
  sha256 "2bb466e38ca2189baa5734a8b585acfbf51c5de1c01ec4c4587e98b28c44866b"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2719a97281689800a683a9ee2a6147cc43b99006a68c321316b315f07de7a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2719a97281689800a683a9ee2a6147cc43b99006a68c321316b315f07de7a39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2719a97281689800a683a9ee2a6147cc43b99006a68c321316b315f07de7a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "0781a30b1a5e05adb64a80ae4997dc6d980bf9b603526b2b37e3dfb0956ad894"
    sha256 cellar: :any_skip_relocation, ventura:       "0781a30b1a5e05adb64a80ae4997dc6d980bf9b603526b2b37e3dfb0956ad894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433b706f92139e70c4be5f4b787135d9fd05856929ec43e4762427c9791d5b2d"
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