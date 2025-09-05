class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.37.tar.gz"
  sha256 "820bae5f91ae2498ab714521404e254238ceaa76a5e178d7f2c62585a597ef70"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd863dad65eb916989574bdc2bddab8813194753b68cdfe3bc0c5ed7db866e92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd863dad65eb916989574bdc2bddab8813194753b68cdfe3bc0c5ed7db866e92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd863dad65eb916989574bdc2bddab8813194753b68cdfe3bc0c5ed7db866e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "f036516154d4a6570dc2a390ac396c2e7fb7fb240aceca4724cdf5bef4db3d1a"
    sha256 cellar: :any_skip_relocation, ventura:       "f036516154d4a6570dc2a390ac396c2e7fb7fb240aceca4724cdf5bef4db3d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a67967f3b078d7b7bc680225486a679a56cd3088fcd2dba70366b0c0801f17cf"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end