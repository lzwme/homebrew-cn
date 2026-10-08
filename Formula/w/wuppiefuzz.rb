class Wuppiefuzz < Formula
  desc "Coverage-guided REST API fuzzer developed on top of LibAFL"
  homepage "https://github.com/TNO-S3/WuppieFuzz"
  url "https://ghfast.top/https://github.com/TNO-S3/WuppieFuzz/releases/download/v1.8.0/source.tar.gz"
  sha256 "8405309fc4b51fbabda282540c25605a00e741b4f3c0c73fe8e7a594ed23ca9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6dbd1eaee49d6d4d3d0e6fdcc191c15216d1ca57a56817e0f1d0ae53b54e20d4"
    sha256 cellar: :any, arm64_tahoe:       "8539462a559f5a57c64a6e59301243461236331c98d62bd02daa380d43917f34"
    sha256 cellar: :any, arm64_sequoia:     "0777f4f82476c638b4116e55b9614164fb10c3e405ed530b915b51827f476819"
    sha256 cellar: :any, arm64_linux:       "c37f274554993d531a4dfaac0e3c7249852e4927af3445f06976e68c69bbcf3d"
    sha256 cellar: :any, x86_64_linux:      "5b7bacaf90a2947aeca09cc1f37a02e25271ed5f70f1442fc7fb3373aba42a17"
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

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    system "cargo", "metadata", "--locked", "--format-version=1"
  end

  def install
    rm ".cargo/config.toml" # macOS `-stack_size` flag breaks proc-macro linking
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
    assert_match "Error: Could not extract server URL from API spec", output
  end
end