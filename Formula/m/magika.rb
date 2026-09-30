class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://ghfast.top/https://github.com/google/magika/archive/refs/tags/cli/v1.1.0.tar.gz"
  sha256 "87fd85f33d2c644d657de024b83cdc36bbdcf4a2961be5e93fe74e081477076c"
  license "Apache-2.0"
  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8a81ed8f18f52553aee8e953448a24e1b69e4b48ab1b245fe249c39ed23da7d2"
    sha256 cellar: :any, arm64_tahoe:       "480c09eafe3216325a36608c11b59485ccdaa8477b523fcb7082a8ffbebdf728"
    sha256 cellar: :any, arm64_sequoia:     "2d29a11e2bf2cdbf9afe3554ed856bc284f3c65b5e66c3761242013532d4e6a5"
    sha256 cellar: :any, arm64_linux:       "93c9a3ab21223fb6e28993966a46dbd729e765cad665b005dc437b96716157f6"
    sha256 cellar: :any, x86_64_linux:      "2053551f6042a33de1f4717e831ddb4d74a58f526cfff141585afdd7600c4dfb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/cli/Cargo.toml"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    ENV["ORT_LIB_PATH"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end