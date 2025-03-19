class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.21.tar.gz"
  sha256 "682aa8a9da71f18ee2ce5fb0271398e486ddf7b42232fc666f7b3f41f12d89c3"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc001249a5d07784ac94d279ae860c348f5ab7e8804e574f4bcfb2cbd5869791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc001249a5d07784ac94d279ae860c348f5ab7e8804e574f4bcfb2cbd5869791"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc001249a5d07784ac94d279ae860c348f5ab7e8804e574f4bcfb2cbd5869791"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec9274000b79b66dbdf02f659f09bf63095d2476a529e11ec33338b6d84364e5"
    sha256 cellar: :any_skip_relocation, ventura:       "ec9274000b79b66dbdf02f659f09bf63095d2476a529e11ec33338b6d84364e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e4aad190c1b6215db2f9a98b1506e25bed415ef0cae437404ce02938b42eb5"
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