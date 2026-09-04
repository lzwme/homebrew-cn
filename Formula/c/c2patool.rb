class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.17.tar.gz"
  sha256 "818c7a6a264ac4cac045bc32464209656682214a0cc47aa356606d5957245fb0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5eaabf550f33f1dc3ccff817498abd8bb5dc0b339094053bde9563f9326ae2e0"
    sha256 cellar: :any, arm64_sequoia: "e2061aa3161768c716083b9bb47e07bda4fa57b5a50ea8792222e65dd3d22554"
    sha256 cellar: :any, arm64_sonoma:  "85ba202aa15f7d9e1a0ff3ac6f39584ba607eb23a0c394889db92e2cfeae9a86"
    sha256 cellar: :any, arm64_linux:   "df7b151f20eedc98cf4ba2292c12ce1be6ffd871f74473d2a81809ea966ec501"
    sha256 cellar: :any, x86_64_linux:  "19bc954c25261e5c1c04b090b793748ef3d99ac71f6571a8234b306698cff98e"
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