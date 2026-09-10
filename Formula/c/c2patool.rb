class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.27.21.tar.gz"
  sha256 "1f75efb9d9dc63b5d7b03e9c9e3d5ff89c3118701d92b8ea70e076389b8a59b3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "01f277ad5e2919be59f7f57e06a804544c414565d0e3a0f381c11c3d597b91f8"
    sha256 cellar: :any, arm64_sequoia: "1fc1587c46bdc04db768869fb3d1f4428addbd2ce8b4d4391d67cef2bfd60d98"
    sha256 cellar: :any, arm64_sonoma:  "c7a625b25f042b6460223dfa442cc30e2486ce328b723b0c46416e8ce949a260"
    sha256 cellar: :any, arm64_linux:   "6474455cb125cb17836016cfdc1df5dad79cde1de942aef744a64bf920af320d"
    sha256 cellar: :any, x86_64_linux:  "df1e146a44c9127b00857f04ddd23294165b7d411660052174a748d4446283a5"
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