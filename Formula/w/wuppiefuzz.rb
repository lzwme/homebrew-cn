class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://ghfast.top/https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.6.0/source.tar.gz"
  sha256 "f22bd5f0f1f922dfa1481e752689fe043e49f68bb1139fab195359b388e461f0"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df9f25e21e11e0ebe202de87eb68322cf92191d5a26c3b6050957e81603c6f82"
    sha256 cellar: :any, arm64_sequoia: "722069035b1382f0dffe55dc0638b0b932c811a92b6c17c6d5e92f0bdd6d2f82"
    sha256 cellar: :any, arm64_sonoma:  "dbe894d16d60a1e4b8f2774db98fcd7394cf80d1fab5a5068266499a6566a759"
    sha256 cellar: :any, sonoma:        "514b80ff1467e5808e1db4e191972716cb7e02d9e9f21af5a096e532dd207c4c"
    sha256 cellar: :any, arm64_linux:   "dd1af3e344e35d7910712c2f4349f925448e5a75f6822d97314a2fe07a2ecbc2"
    sha256 cellar: :any, x86_64_linux:  "9a4f262b21b375fdd44e49f7c6ffe7971a68e8cf12b7e018bd5e427c0a3eac4d"
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
    ENV["Z3_SYS_Z3_HEADER"] = formula_opt_include("z3")/"z3.h"
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