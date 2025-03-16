class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.20.tar.gz"
  sha256 "92bc399f01628991b719d4b99eab9207d2cc7a0da9bd60b935e9a8951723159f"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6d4c58ca07e77659bcbf9fccfc87edc2747667192cd988f63fe33431f3a5e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db6d4c58ca07e77659bcbf9fccfc87edc2747667192cd988f63fe33431f3a5e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db6d4c58ca07e77659bcbf9fccfc87edc2747667192cd988f63fe33431f3a5e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff787febf01102cac10e4de8f41d60b8054de7e55e1f69ab458f3908d310e26c"
    sha256 cellar: :any_skip_relocation, ventura:       "ff787febf01102cac10e4de8f41d60b8054de7e55e1f69ab458f3908d310e26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331a687ba86a088c70d7ef5c13c7c86875e4bec52e72521406e0453d5192d890"
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