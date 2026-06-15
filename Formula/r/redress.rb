class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.75.tar.gz"
  sha256 "ca44859e236db18b30b8cc67ed8560f7f9b822e5648f362048f1de5f09b406fc"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "087b64c75a8d1d6f0961ce6361770f9e4fbb5449c04574c3a0740e7131b1e413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc3b7cdbc4aecce17696a7677e0affe1418b6a481b41abc1be283e92b0f3dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f0ff0fee0bd08634f74bdc3b4f7d9cc4b36d2f0eac9b0fca523e55ea72f7f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c712bd41dd87dafded75676073d177cbe2804b31c7518b5aef7d62ed670455d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c223baeab5464d64cedb5018e631d22eaefea60c826c4b57787b3c70dfe038d2"
    sha256 cellar: :any,                 x86_64_linux:  "fe36fc0416ad90a17b62ddf8a18d2f0211ead1acf4fe483867c54efcff04daaa"
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

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end