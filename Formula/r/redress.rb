class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://ghfast.top/https://github.com/goretk/redress/archive/refs/tags/v1.2.57.tar.gz"
  sha256 "77ce2c3c8705d8b556d610d497e99c84a4056438ef6284acdb9b54c454001483"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e0146a12a88ee23c0f8d1675f515438830a2f9f2bb9296e55915120e4fbc698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b96986b97fd1c70a897991fc2d62fd951ee1f2efdae07adf94be5efd1a1407c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09373a0ad6cbb1e6f778b79a29269ad0f162e7c07a9d96d025da04bed52b098"
    sha256 cellar: :any_skip_relocation, sonoma:        "151455b0a26a4f1cdbfe4d6be27f5e9014a09b262025ff9c402d879ebe306a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53caafd3aa3ad9ef3e229ce8924512cb1279b8479f5364b8ceee7579cc5979aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6834807f6cac76d033e26ac02811db4ecac86b520bbdc33ffc74ca9b1336704"
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