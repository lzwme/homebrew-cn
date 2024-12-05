class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.6.tar.gz"
  sha256 "437e97e5afd107b992ad4df82c69fa0690535cecc1ee517d6e2fd776ad779fcb"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "160d7773f35dfb07ab240621bc243a6cb15cdb1c0a5afe345316d64a37d46da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160d7773f35dfb07ab240621bc243a6cb15cdb1c0a5afe345316d64a37d46da0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "160d7773f35dfb07ab240621bc243a6cb15cdb1c0a5afe345316d64a37d46da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "892ece164fcaaacc407d7892b3bc9d5bbb16c6b35dcc517dbfdb58079bf83b12"
    sha256 cellar: :any_skip_relocation, ventura:       "892ece164fcaaacc407d7892b3bc9d5bbb16c6b35dcc517dbfdb58079bf83b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828e0822ddcfa77c1881ecaf328551d8316fc6df0b060dbe9f9c0d2c54d8a936"
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