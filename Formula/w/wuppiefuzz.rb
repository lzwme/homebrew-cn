class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://ghfast.top/https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.5.1/source.tar.gz"
  sha256 "36fc2fade7e3a3901540c751f0e29c456ecb434dd171960e32a2d338731c09c9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "45600a8e3e8c3e4d5e0c7e73d585289dc11f2b49d83687ec840b807215b996fb"
    sha256 cellar: :any, arm64_sequoia: "468c2d2e9c102846d9ceb3566947bf285754a277e389971e1745d0cb18bc2c60"
    sha256 cellar: :any, arm64_sonoma:  "cd8b0d6dbd2b15fd1bd87737809f376c29e2628429e025b3d0718cf25652e07c"
    sha256 cellar: :any, sonoma:        "a46d8fbb0f066ae740a129388a10dfd7864d4ffbfdccf3a18bb90352f26e4a30"
    sha256 cellar: :any, arm64_linux:   "023b77dc6149ad6bdaee167066ef0175bea0a94fb840a99c1d3373592f91c306"
    sha256 cellar: :any, x86_64_linux:  "13f49800bb6de3aa0ea596fbcb5383b32d7c61f59bf66533138bd307dc269ea2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "z3"

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "sqlite"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["Z3_LIBRARY_PATH_OVERRIDE"] = formula_opt_lib("z3")
    ENV["Z3_SYS_Z3_HEADER"] = Formula["z3"].opt_include/"z3.h"
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: ["std"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wuppiefuzz version")

    (testpath/"openapi.yaml").write <<~YAML
      openapi: 3.0.0
    YAML

    output = shell_output("#{bin}/wuppiefuzz fuzz openapi.yaml 2>&1", 1)
    assert_match "Error: Error parsing OpenAPI-file at openapi.yaml", output
  end
end