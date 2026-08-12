class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.10.tar.gz"
  sha256 "255ddb62e6bac00023db17c4d15a32dc5d7876bed078d04fd76ff676c88168b4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8b6d58b5bceb94a6fcbd17db04969b5447445c2690e8d8b63e0d5a16123fe431"
    sha256 cellar: :any, arm64_sequoia: "98b2af364f986cef685e09219a647e2b5cbec979cf9755c190a2d8bd1e977669"
    sha256 cellar: :any, arm64_sonoma:  "e31e8dcda1c288a5264c6f137542d5c270cedff347f71c47c43c4410cdf39bcb"
    sha256 cellar: :any, sonoma:        "fe9aed4b29209abf58a2e9507d78c3ea81f49bedc62e8f0a1994d2a0047dfe3c"
    sha256 cellar: :any, arm64_linux:   "d9cc693c9bb4a256d44ff0684b137c4df1e71182b031135cdc46828bea78ede5"
    sha256 cellar: :any, x86_64_linux:  "7ef8de938f66e767638f9d29d929d2438f2f11cbe51150de4c3b20455909f051"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end