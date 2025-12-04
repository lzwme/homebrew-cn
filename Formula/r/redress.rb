class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.48.tar.gz"
  sha256 "0fe0514fdb693b5e403328b28141040e5d25fe1f4e6a9f70f68854c26a76be54"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50338648b49cbdc7f5fdd329f29926300d4fa110f36d777b70ab017def0cdd13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4afe276adce9d4500e7b0425353311648463ebe61b11d3f4bb23ca8c1f2406d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f94f763c1e429ffe91f1536eca53331144fbeac204fe8da74383321c211d6e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "017a68b2ff7875b3764432d9ebe8c085587f097a9d4f00d25ad00c136524e218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9f3618db66789818171b94213c74743f8eec787d0066ed5bfba003fb2f8fee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff521938bda15295259c2d2dc03907c9aff10d5c01c9d24478eb8d4af18ce86"
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

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end