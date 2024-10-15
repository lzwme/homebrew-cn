class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.2.tar.gz"
  sha256 "1f74307d9913ce2f266bc50bcfd77dd4d34d1012a93fce94cbca84d174cadfc7"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f9c81a3cb45df9dec767903752e8fe914a4816a12fa5400a0a7f8f71e239061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f9c81a3cb45df9dec767903752e8fe914a4816a12fa5400a0a7f8f71e239061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f9c81a3cb45df9dec767903752e8fe914a4816a12fa5400a0a7f8f71e239061"
    sha256 cellar: :any_skip_relocation, sonoma:        "687295a56f56f209dcb093883ec3eecfa96a5a72506e5055fdf42c3c7ce6f8b1"
    sha256 cellar: :any_skip_relocation, ventura:       "687295a56f56f209dcb093883ec3eecfa96a5a72506e5055fdf42c3c7ce6f8b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "481674166beb4c31d931177b571abf721d135799d8279e3f60ec14a7fc712154"
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