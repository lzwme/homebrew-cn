class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.80.tar.gz"
  sha256 "2260de8c6d451ae176701a8d56df6d605eadc1d131223acecfc17d9f0e7c5e4b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9b1d9d0ad27e47e126b108e3543be7779c57690bd3e50868c9077ae458384ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe32ec8d94918a2ab0f7918ff9bda9a747702922b5670bf367c8193b2b6f2e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d1bc689e8a6f8836ff58e2f7588659d122a88b1f3124440b416c00522cd4157"
    sha256 cellar: :any_skip_relocation, sonoma:        "86db9e6ad41a98dca7293ce45966fe77946f7e36bd82f9b8589cb10554dfc45e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ce185be719f591d6d1611c998b92256e870b826cebc3a880b794ede33e668da"
    sha256 cellar: :any,                 x86_64_linux:  "81e65f254766dcb9f82ba1a01b30d3c382200b58560d6be3d5c79b97dfd1e9c1"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end