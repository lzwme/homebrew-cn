class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.35.tar.gz"
  sha256 "67b275f51fff7a331ca9ea590da6d05827e1c6ef30d7641d20d8e2d431412c0f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d1c1846ca9db8d0fecb6fbbe663bab39ad06158f3dcc2e0975a00e37e051f97"
    sha256 cellar: :any,                 arm64_sequoia: "a12e3ea95e9304e36d3389f60c79fe761ace7ef0f14404911889799ec7e9d4d9"
    sha256 cellar: :any,                 arm64_sonoma:  "d91562d8f7eb363c398a97a81859e761c083ba05bafac1ef44580284f625ac79"
    sha256 cellar: :any,                 sonoma:        "38549a5cc37feac1e25df76b399cc03ffd4449bba2f5f6d4e76c9e3dcf633926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e72537e920f3cf819a894373914e853ade031fc4fe3e4517366a8bc23df81023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8640018d26ab65acaf3459947d02739be3c6bc047f779a09ffe032be8811a6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
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