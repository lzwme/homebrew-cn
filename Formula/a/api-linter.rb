class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://ghfast.top/https://github.com/googleapis/api-linter/archive/refs/tags/v1.70.2.tar.gz"
  sha256 "65183397e976213c100d10ac2fef7843972af793e7b4224f53ef7fc5f342e132"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8784515e005425238475f7035c1c9537c3be471dde6e326c41b559aa43eadd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8784515e005425238475f7035c1c9537c3be471dde6e326c41b559aa43eadd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8784515e005425238475f7035c1c9537c3be471dde6e326c41b559aa43eadd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb8986b52152d6dc31e38b8f2ca2d049dd05cdef9a97e0690d5ef3514fb80379"
    sha256 cellar: :any_skip_relocation, ventura:       "fb8986b52152d6dc31e38b8f2ca2d049dd05cdef9a97e0690d5ef3514fb80379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6d4d45bc1ebdb78443007a80a6b28b815817cecb6d63b5038f8dec67368ca6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/api-linter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/api-linter --version")

    protofile = testpath/"proto3.proto"
    protofile.write <<~EOS
      syntax = "proto3";
      package proto3;

      message Request {
        string name = 1;
        repeated int64 key = 2;
      }
    EOS

    assert_match "message: Missing comment over \"Request\"", shell_output("#{bin}/api-linter proto3.proto 2>&1")
  end
end