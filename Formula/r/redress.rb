class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.8.tar.gz"
  sha256 "c6a43b1b17787dd97451f26ca4ead3cf1853d282b9922aab10e18efbf4c17a61"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd553dbaaf1f364c9155929e0548a208700fce6566f80d96c254dc715effe3db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd553dbaaf1f364c9155929e0548a208700fce6566f80d96c254dc715effe3db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd553dbaaf1f364c9155929e0548a208700fce6566f80d96c254dc715effe3db"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2af639a78e7250991ba97b48f941c94a39ea92d75ba71bbd590648930c92f6"
    sha256 cellar: :any_skip_relocation, ventura:       "8a2af639a78e7250991ba97b48f941c94a39ea92d75ba71bbd590648930c92f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ecb99e4c470f8816572d909fe4de6a0f90422dbcec6c1bde398f4f94a11165b"
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