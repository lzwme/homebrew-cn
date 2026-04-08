class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.62.tar.gz"
  sha256 "e7ba6a233ef8cc0ab7fc18d13ecb2bdef43e8b762704692ffd381f644d79a37f"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a571652e0d3aba36f8cbfeef0f7d139f2a7a22267816b6f8334525664c04345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c63ff3c64c853da9ccb66176edb1c550fd2ea142385cc706d16117a8565143a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f122ba1065da8c64568564239632567d86f6e6673d6fd0d14f50a95b495762e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f552779a1b20f37191af0006743d196aac28d5485ac98800a43462e539a2d7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be2ec0c6c42538295807ea1f28c42822d1626065ea16f3104c6be5134516221e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eca3ff42785ffd58b963e2fe8973610b4f3b66074f3e80cd38110ce465d94fe"
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