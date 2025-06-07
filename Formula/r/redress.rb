class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.29.tar.gz"
  sha256 "3e4c99c8359d6c20c9779bf0e534afc3117d034e39838f8fa90749e887971f8d"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ecf7ff0588ce317a4c5c6567ea8060ef8b6bfd14b9601b59f5c322c5b6f9271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ecf7ff0588ce317a4c5c6567ea8060ef8b6bfd14b9601b59f5c322c5b6f9271"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ecf7ff0588ce317a4c5c6567ea8060ef8b6bfd14b9601b59f5c322c5b6f9271"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb0db2ca2d38e25fcec093d719ac0c387005707a64e4fe6c23b52c2a1838c81"
    sha256 cellar: :any_skip_relocation, ventura:       "3cb0db2ca2d38e25fcec093d719ac0c387005707a64e4fe6c23b52c2a1838c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a597c4564413657dbcdb4a66582c58747e4561c0e9b0ac60488feaaa03c2287"
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