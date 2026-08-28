class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.16.tar.gz"
  sha256 "984591da9cf8d96a17f56beee3ef5fddd5612ba6e829b73eb9e5d07796085514"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0ad5bad9550f2b2845d5aca749266c6dc68562448fe05b804ceecdf1d0ff2974"
    sha256 cellar: :any, arm64_sequoia: "5e657ba62dad25fe941138734f114ffdddaf4c683605991d5721fb758d6c6db5"
    sha256 cellar: :any, arm64_sonoma:  "476d5b9e1de4244a28dcd2d1ad6b0a9049d1e5b49694e9e8e7deff5494d6bf1b"
    sha256 cellar: :any, arm64_linux:   "27bcaff98d66c5dbb8a9d80390c07d0c828ef0cb360bd3c3ab1930dcf7cc94f3"
    sha256 cellar: :any, x86_64_linux:  "dd14712886ea7505e279157608f575f9f0bc9530d7519526df746c6f28287cf0"
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