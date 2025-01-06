class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.9.tar.gz"
  sha256 "42a7ccbd17201b7f7d56da4eb26e062c607152de06de4662e8c1a746de13b36f"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28d05863333c6bf80c7869883da76ad743d5f1a870d6e75bb8426c092d96bc9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28d05863333c6bf80c7869883da76ad743d5f1a870d6e75bb8426c092d96bc9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28d05863333c6bf80c7869883da76ad743d5f1a870d6e75bb8426c092d96bc9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1efa5b92becb7e7d83dbaeff5957fb004ac1646cbc85886a88e5fbe136ce85e"
    sha256 cellar: :any_skip_relocation, ventura:       "e1efa5b92becb7e7d83dbaeff5957fb004ac1646cbc85886a88e5fbe136ce85e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e99cc377eebce125735a1d07dffd9425efe21710771e8f16ddd46fea6d9394"
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