class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.60.tar.gz"
  sha256 "7dee98bf85a12172b7cadc56da9070b22cfdd921742e4249acb0d26517e2f16d"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c7744f55291ee60ed93aea0b61c8db5cc475e97e122b6dfd2e77dba4b9fbf5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d627355872eba81f4a544d5d8348e6cd3ea81bcd45158a2d7bb8470282edbb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1ba9b36fd1b80779ff9dc989eb6c13cb718413f4b0e73059788e8e9f13b4dce"
    sha256 cellar: :any_skip_relocation, sonoma:        "200d7a654d06ca19b34cacd20e6689090798aecc45b1c91108b5bcc5463960a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5c474f66748f7ee8f513db2e35f8c26f3b06a9335a072053bc573b171f0c6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "640cb30738a52a93b3e3f85300272a7f67f262f77248cc05eb304b80262238cd"
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