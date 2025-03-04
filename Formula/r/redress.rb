class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.17.tar.gz"
  sha256 "8f8e5af0098729671869e3cd5d1ebbe955900dfdeeaeb71f5e50810f33c19313"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fff9782c09a6c2c6796a0f293703982472720cae2b272231d52fe69337f46b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fff9782c09a6c2c6796a0f293703982472720cae2b272231d52fe69337f46b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fff9782c09a6c2c6796a0f293703982472720cae2b272231d52fe69337f46b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93190b3662a716cf7764584eb35b2645279873db3059befed5038c008cca952"
    sha256 cellar: :any_skip_relocation, ventura:       "b93190b3662a716cf7764584eb35b2645279873db3059befed5038c008cca952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ae8dbaafbad73676f3bd441ba9485e4ad572e94ba453e990bfe082bbc1d372"
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