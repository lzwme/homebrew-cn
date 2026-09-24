class Magika < Formula
  desc "Fast and accurate AI powered file content types detection"
  homepage "https://securityresearch.google/magika/"
  url "https://ghfast.top/https://github.com/google/magika/archive/refs/tags/cli/v1.0.2.tar.gz"
  sha256 "bae42b31c8f419f34043cc2cf26fa42d2ade7f7c91e2fb54919914432f799699"
  license "Apache-2.0"
  head "https://github.com/google/magika.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8f0842fc6d7d138c129444d04e10b8e3d0471daa0cc1f97e1939eed15bb630df"
    sha256 cellar: :any, arm64_tahoe:       "0cc828c0f140e1703e72440d31a55258f3abd1b0989ea04c37de18facafa4da2"
    sha256 cellar: :any, arm64_sequoia:     "9110a79c00a38458f82ff85580735a022630edbc276bfae22201ac9cf936e040"
    sha256 cellar: :any, arm64_linux:       "d5294a877f99d126003f2093d2e230c0f7d3d11dd2dd2ea5319b7d0ee9a394e4"
    sha256 cellar: :any, x86_64_linux:      "2237f518b1e31a7dc428b99624652da1bdfe946b08a2e0efac1e461cafe69740"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  on_linux do
    depends_on "openssl@3"
  end

  # Fix x86_64 build compatibility for ort/ndarray, upstream PR ref,
  patch do
    url "https://github.com/google/magika/commit/f56ab8a0806c67a2ae87edc6cd032684d592b978.patch?full_index=1"
    sha256 "7a3f701733c4df5ef0aceba3b7854f1d8e0f2a23c4fda95804911b0fa5e6ab9c"
    type :unofficial
    resolves "https://github.com/google/magika/pull/1312"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/cli/Cargo.toml"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3") if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "rust/cli")
  end

  test do
    assert_match "text/markdown", shell_output("#{bin}/magika -i #{prefix}/README.md")
  end
end