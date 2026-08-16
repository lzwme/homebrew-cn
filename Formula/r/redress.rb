class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.81.tar.gz"
  sha256 "608cdd5e7ed657715ccf4d40b8fe97f0930080e5054024ac530ce8d8009a80e4"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa7a36d52c8a577ea19d8cc32ef18ba46377a8ebe063ea7d6ba85e26cf1efec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c4b756419609b28ae34b1226ff2307a78f5d11529f53586ce8cc5e7527c138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f378abdb05d9737ec6e2d83e614b954ac54e0170c459ed652bd7de8f2e08eed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8de56b9bff2d855bc2d82199d6087ddbc3ec7599005822ade544eda672251252"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "338e0ef97b6e90cabbf5e14ad96f1dfd35ecd7056a1a66486ce05c9216554da2"
    sha256 cellar: :any,                 x86_64_linux:  "137a10b2b215bb3b619ddff9db942b6f82f6cc46c54485f0590c94027ada6528"
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