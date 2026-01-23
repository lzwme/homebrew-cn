class ApiLinter < Formula
  desc "Linter for APIs defined in protocol buffers"
  homepage "https://linter.aip.dev/"
  url "https://ghfast.top/https://github.com/googleapis/api-linter/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9b514fb9d1285e3bfcbeb57737c32f0f92145feed079431c9f314abb4f964e56"
  license "Apache-2.0"
  head "https://github.com/googleapis/api-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70bab77aef34de7373d0b0ad15c114dc4f6c6f73958264438f5111af35bc22d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70bab77aef34de7373d0b0ad15c114dc4f6c6f73958264438f5111af35bc22d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70bab77aef34de7373d0b0ad15c114dc4f6c6f73958264438f5111af35bc22d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4df69faf4d3d65ce326a8a7a863527a7ccabcada977adc31cd5c0afef85b42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2972415beb73d8018245193c84c42b15b7d52bb4682a04d61c6a4d17132002d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e9700bed037a9f1fedead7b9a9186f89e6c62a575f8d52f92dd1cb9c74c3a3"
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