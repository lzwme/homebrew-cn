class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.12.tar.gz"
  sha256 "9b40a7c64125a6176feda20daf6555017885beed31b6d99fec4ddfc8e0a8bdec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a49469307aab47e2e5f375f34b5af0c809108f25b7aeceee8ddc2a511c734ca7"
    sha256 cellar: :any, arm64_sequoia: "5bea97758ed0f0178676ad9f4f8934fbc662dc44087a120a7822358e3a498b48"
    sha256 cellar: :any, arm64_sonoma:  "4ad6f77d604108d1917888aa045e8ca2c50f42a37e23082d5e588f105308aa55"
    sha256 cellar: :any, sonoma:        "4b475b4ce5f8f60295075ade1157fb6af5114283e7d72f97a7a5f9bff0116815"
    sha256 cellar: :any, arm64_linux:   "e987f18fc6238d63eda8b120c4dc9c5831f3e1bd685ee1d19c42a7fc43b331e0"
    sha256 cellar: :any, x86_64_linux:  "51f2353b7f813549ba1c5dcff44e26160761c8e2453cbab6a13af3b67cb72938"
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