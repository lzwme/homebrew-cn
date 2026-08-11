class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.9.tar.gz"
  sha256 "727c51eeb1a104b07f410385fc9c466723c396ce2d11dc1fba7ff5fd5295bcef"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3371fcfe4a4d44b1a00cf71295bb7189f97e098fd4918546420c2188eee4a199"
    sha256 cellar: :any, arm64_sequoia: "82bf9b1150bd2c2860b79b1b88608703a65b9f8246372580db9e2bc0add11130"
    sha256 cellar: :any, arm64_sonoma:  "fd1e0ee180f134354e1eb93a31950cdd1614b0ddbcfa8be7233762e8410b2c03"
    sha256 cellar: :any, sonoma:        "ff3caeb89590ffb499e3687e02c3077591ad34ed6fefaeba9b0ec5a222f90cef"
    sha256 cellar: :any, arm64_linux:   "ff06e933890bc37586d88713309e73ae2e31a93f32c4f4400865ee1b4fc1e7e1"
    sha256 cellar: :any, x86_64_linux:  "b933bdafdcfd6a612d3d4d123d946741b336b01ae156fdb6b20d1b61a5f74473"
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