class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://ghfast.top/https://github.com/googleapis/api-linter/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "959e2cf0b1c8c78eef3a3293d9ab023b5c13ae1d1636a6c09aadd3408a431b5d"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c532109ad5cff38e82fb1c99436c48b373de67f98ab3fad583f4d9cd730233a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c532109ad5cff38e82fb1c99436c48b373de67f98ab3fad583f4d9cd730233a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c532109ad5cff38e82fb1c99436c48b373de67f98ab3fad583f4d9cd730233a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ef3124294dd1acbb6b76282717d9c0dfbe4bd83ba8c27b2b7a14ad39daaebd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c566020d250b6ada2b98db582eb50bf1d9f3ee4d829089ca4907ba4b61b94976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70623acdbee90ba6da0022804b7111c41e4c7c5b55df1a45bd9ae1cd2e20631a"
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