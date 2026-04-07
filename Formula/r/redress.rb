class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.61.tar.gz"
  sha256 "7f75b37476dae00f8eb64ff69a76125bd60417523e38df878099961acdadd1a0"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5c13b103e3a8af90918680c833152bf524d6eddafe967eb14b23d1a09fc675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d15d4f43dc372ee247e8219c13f77145c912b79c19df7c472495d250af1f02fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c21e9b205e4312046ad29b7c2213248a88df6ee73b57687efb5be3ed26a5dd6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d812b1fb45955f6c28c584c93bfe5a74ed29af2288ba5a3c299bac0feb3f0be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3a8d5b83b6098614b35d00252f7c5eac4a69b9593f226c5a9c7d31c7a865d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f2c8fd95df8ac8926b4dfbe809de2b11acd7ed07cd6b1c44a6215b187c9864"
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