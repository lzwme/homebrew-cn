class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.5.tar.gz"
  sha256 "beff5b97d69c398faaf0966fb164de28bc4da25b3505844b82d8fb607003d033"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c2f679f9d24bcd61580dcda2cac2e729079b28ad03f9fee725025b72fa3c7808"
    sha256 cellar: :any, arm64_sequoia: "cb0f3b273fefdc715d7744a37e6e2b97775871e74987b55d0e3300ce98c28c48"
    sha256 cellar: :any, arm64_sonoma:  "8747233f9ec3e8a5553a2cc03d563aa03e0ed566db74b5d893b6f215d7aec953"
    sha256 cellar: :any, sonoma:        "7332355885e6ff88b3b8ff8b9185d166e40d487658376ecaf4407be6989fda08"
    sha256 cellar: :any, arm64_linux:   "fb5bee3c7d3546bdcd5cadc05cdc444344ad6ef0eaa48fb127a28f79fc21b7b0"
    sha256 cellar: :any, x86_64_linux:  "31cfd868b198f05c31a8512e52cbe194286d58e17b460ecc1ec2e1f75c1dd501"
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