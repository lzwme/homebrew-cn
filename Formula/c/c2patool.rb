class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://ghfast.top/https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.70.tar.gz"
  sha256 "6b3c4e91302d356f54cdae84a2c0ee1dbb4cfec1bb1efa28377900fad98db634"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af2ce6c0fa7788919cdc4a8e4d47a7150dd30699a22061ac1ebd3abf35ce2f8a"
    sha256 cellar: :any, arm64_sequoia: "23e6565b26cb298d12c6d03db50ae81acdb9830b3490974837b08f93249d85ca"
    sha256 cellar: :any, arm64_sonoma:  "602e14632f459ff03e8a58c43cfcaea8d426c8671d7c8cb60468917b4eb6af5a"
    sha256 cellar: :any, sonoma:        "48e4d41f40ff9d21544351d4f706abf90ce1c6f73fed68923706a7beffa9d0b8"
    sha256 cellar: :any, arm64_linux:   "18014bcde920c751a91b2ca75af148b7cf2137eb01df14e68b9a91e6fee908c9"
    sha256 cellar: :any, x86_64_linux:  "1e90b4b8160cdd8168e824490444dfc1dd0bcca0326790a1c6b4bb0e5a95ddb6"
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