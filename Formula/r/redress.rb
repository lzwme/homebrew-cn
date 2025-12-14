class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.49.tar.gz"
  sha256 "e657b47fd4b5cf1bb7981f52f6697fc3c913ebee68b39286434f55be296fd0c9"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7d0d645ebd94a41c696c5589df5f0924ee0eed669c853d2ddae1504c9608a71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58777e36ad88d6fa2002e7aa10d2e55793ca8586c4f71885400bb4db3d0ad69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8c609283f6c876ef7ab089eea4c15591ec8f2b4d7c31c20630879389641d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d4b6ff666576ee731ac397fa2bb843e3919d6ae91b00c82f0d738afc5794f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a1de3d6f8df2af5f61c51937c6c401aeee107d73d3486536a0cb9d18ae7a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712b2d6ff55cbbf67d4f271d09c303823e10bf5b3dbd4d76a012ba1c302fe8f7"
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