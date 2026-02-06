class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.53.tar.gz"
  sha256 "ca394ea1753dcf956bcbbb245d47b0d8a1cebaeb451ce87da6e727d132f65f26"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24fe2c3e8633ec230045f043d9f9ebc7824dc246b4093330057d3e1e29a77837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99e23c268a05594112e606852b66b13811ef9a3160fb83bef27c80ff0c270321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f54301a163aa3ac2dbd76e49568d9d103016728d7a39d43edccc74473572c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2552b6b5f37a9129a5e1a63b033a7dfe4b4df3090fc3c8dc5c46d2e5f7e5d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e75e841067239e322ce28ddefbbe3dfc0325bb5b12ff0a49584b68fe860a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9a13dbcb24b336496540c5ce860cba931a4a93f12a93523baaa1ada101e8f0"
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