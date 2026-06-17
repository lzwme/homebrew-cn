class Buffa < Formula
  desc "Pure-Rust Protocol Buffers implementation with editions support"
  homepage "https://github.com/anthropics/buffa"
  url "https://ghfast.top/https://github.com/anthropics/buffa/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "511c626799c4b890b44421ec5d8694924a13153c35a68eefa54bd34031a25bbd"
  license "Apache-2.0"
  head "https://github.com/anthropics/buffa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b794d2b90ac426a78c214511c566ee851cdef4b5fdb6faabf90818d0d1d77ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8303a73d81f7cf80c93e629df895adfac6ca16f22af5ed9aadae29eeaa1b8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c49d96cdb75c0eeedcc7019c42ad63fadd45c64e9831e3bb1ea50510e2c8f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "368fccd711f1e356929dfc06cdcbc3a75590661c76f4f76bd9513ceb8928d25b"
    sha256 cellar: :any,                 arm64_linux:   "bdfec1cabc75e02626d2d24e9857141d436ba6960aa3e7343eb12c51f17b1aaa"
    sha256 cellar: :any,                 x86_64_linux:  "12b7f83ee1e20ab9e75e55c30f9a0240c65d8dbc96fda10933589372c4b7ca9b"
  end

  depends_on "rust" => :build
  depends_on "protobuf"

  def install
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa")
    system "cargo", "install", *std_cargo_args(path: "protoc-gen-buffa-packaging")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protoc-gen-buffa --version")

    (testpath/"sample.proto").write <<~PROTO
      syntax = "proto3";
      package example.v1;

      message Greeting {
        string message = 1;
      }
    PROTO

    (testpath/"gen").mkpath
    system "protoc",
           "--plugin=protoc-gen-buffa=#{bin}/protoc-gen-buffa",
           "--plugin=protoc-gen-buffa-packaging=#{bin}/protoc-gen-buffa-packaging",
           "--buffa_out=gen",
           "--buffa-packaging_out=gen",
           "sample.proto"

    assert_match "pub struct Greeting", (testpath/"gen/sample.rs").read
    assert_match "pub mod example", (testpath/"gen/mod.rs").read
  end
end